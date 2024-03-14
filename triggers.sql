-- TRIGGERS pour les contraintes dynamiques de la base

-- 1. Lors de l'ajout de l'utilisateur verifier les contraintes 
-- (nom, prenom, mdp, date de naissance non-vides)
-- seulement si ce n'est pas un utilisateur special (par exemple, 'nouveaute')

CREATE OR REPLACE TRIGGER t_user
before insert 
on utilisateur
for EACH row

BEGIN
    if :new.login_user <> 'nouveaute'
    then 
        if :new.nom_user is NULL
        then RAISE_APPLICATION_ERROR(-20001, 'Nom vide');
        end if;

        if :new.prenom_user is NULL
        then RAISE_APPLICATION_ERROR(-20002, 'Prénom vide');
        end if;

        if :new.mdp_user is NULL
        then RAISE_APPLICATION_ERROR(-20003, 'Mot de passe réquis');
        end if;

        if :new.naissance_user is NULL
        then RAISE_APPLICATION_ERROR(-20004, 'Date de naissance réquise');
        end if;
    
    end if;

end;
/

-- 2. Lors de l'ajout de la liste 
-- si c'est une liste de l'utilisateur 'nouveaute' alors elle n'a pas de type
-- sinon le type ne peut pas être vide

CREATE OR REPLACE TRIGGER t_liste
before insert
on liste
for each row

BEGIN
    if :new.utilisateur_login_user <> 'nouveaute'
    then 
        if :new.type_liste is NULL
        then RAISE_APPLICATION_ERROR(-20011, 'Type de liste non renseigné');
        end if;

    end if;

end;
/

-- 3. Lors de l’ajout d’un objet dans une liste, 
-- vérifier que l’objet est de même type que la liste
-- sauf si c'est une liste de 'nouveaute' qui peut avoir les objets de plusieurs types

CREATE OR REPLACE TRIGGER t_appartient_liste
before insert
on appartient_liste

for each row
declare 
    createur_liste liste.utilisateur_login_user%TYPE;
    type_o objet.type_objet%TYPE;
    type_l liste.type_liste%TYPE;

BEGIN
    select utilisateur_login_user into createur_liste
    from liste
    where id_list = :new.liste_objets_id_list;
    if createur_liste <> 'nouveaute'
    then 

    
        select type_liste into type_l
        from liste
        where id_list = :new.liste_objets_id_list;
    
        select type_objet into type_o
        from objet
        where id_objet = :new.objet_id_objet;

     
    
        if type_l <> type_o
        then RAISE_APPLICATION_ERROR(-20021, 'Type de l''objet ne correspond pas au type de la liste');
        end if;
    end if;

END;
/

-- 4. Lors d’une inscription d’un utilisateur 
-- vérifier qu’un login est composé de la première lettre du prénom et 
-- des 7 premières lettres du nom (en minuscules) suivies de deux chiffres

CREATE OR REPLACE TRIGGER t_login
before insert
on utilisateur
for each row
declare 
    longueur_login INTEGER;
    prenom_initial CHAR;
    nom VARCHAR2(7);
    premiere_lettre CHAR;
    suite_lettres VARCHAR2(7);
    deux_derniers_car VARCHAR2(2);
    hasnumber VARCHAR2(5);

    LENGTH_LOGIN exception;
    FIRST_LETTER_LOGIN exception;
    SURNAME_LOGIN exception;
    TWO_LAST_CHAR exception;
BEGIN
    if :new.login_user <> 'nouveaute'
    then 
        longueur_login := LENGTH(:new.login_user);
        if longueur_login <> 10
        then RAISE_APPLICATION_ERROR(-20031, 'Format login invalide (longueur 10 caractères)');  
        end if;

        prenom_initial := SUBSTR(:new.prenom_user, 0, 1); -- récupérer le premier caractère
        nom := SUBSTR(:new.nom_user, 0, 7);
        premiere_lettre := SUBSTR(:new.login_user, 0, 1);
        suite_lettres := SUBSTR(:new.login_user, 2, 7);
        deux_derniers_car := SUBSTR(:new.login_user, 9, 2);

        select NVL(RTRIM(TRANSLATE(deux_derniers_car,'1234567890',' ')),'TRUE') into hasnumber from dual;
    
        if (prenom_initial <> premiere_lettre) 
        then RAISE_APPLICATION_ERROR(-20032, 'Format login invalide(premiere lettre)');
        end if;
        if (lower(nom) not like suite_lettres)
        then RAISE_APPLICATION_ERROR(-20033, 'Format login invalide(7 lettres du nom)'); 
        end if;
        if (hasnumber <> 'TRUE')
        then RAISE_APPLICATION_ERROR(-20034, 'Format login invalide(deux dernieres chiffres)'); 
        end if;
    end if;

    
END;
/

-- 1. Définir les listes des ajouts du mois 'xxx' pour l'année 'yyy'
-- pour un utilisateur « nouveauté ».
-- Chaque nouvel objet culturel ajouté dans la base de donées au courant du mois 'xxx'
-- de l’année 'yyy' est ajouté à la liste correspondante.

CREATE OR REPLACE TRIGGER t_liste_mois
AFTER INSERT
ON objet
FOR EACH ROW
DECLARE
    id liste.id_list%TYPE;
    mois VARCHAR(20);
    annee VARCHAR(4);
    liste_nom VARCHAR(50);
    nouveaute utilisateur.login_user%TYPE;
    user_login utilisateur.login_user%TYPE;

BEGIN
    user_login := 'nouveaute';
    begin
    -- verification d'existence de l'utilisateur nouveaute
    select login_user into nouveaute 
    from utilisateur
    where login_user like user_login;

    exception
    when no_data_found 
    then insert into utilisateur(login_user) VALUES (user_login);

    end;

    begin
    select to_char(SYSDATE, 'MM') into mois from dual;
    select to_char(SYSDATE, 'YYYY') into annee from dual;
    liste_nom := mois || '-' || annee;

    SELECT id_list INTO id 
    FROM liste
    WHERE nom_liste like liste_nom;
    
    exception
    when no_data_found 
    then INSERT INTO liste(id_list, nom_liste, utilisateur_login_user)
    VALUES(idListe_seq.nextval, liste_nom, user_login);
    end;

    SELECT id_list INTO id 
    FROM liste
    WHERE nom_liste like liste_nom;

    insert into appartient_liste(objet_id_objet,liste_objets_id_list) VALUES (:new.id_objet, id);

END t_liste_mois;
/

-- 2. Archiver les listes supprimées dans une table d’archivage. 

CREATE OR REPLACE TRIGGER archivage
before delete
on liste
FOR EACH ROW 
declare
    CURSOR c_appartient_liste
    IS 
    SELECT * FROM appartient_liste
    WHERE liste_objets_id_list = :old.id_list;
    v_appartient_liste appartient_liste%ROWTYPE;
 

BEGIN
    INSERT INTO liste_archivee
    (id_liste_ar, nom_liste_ar, descriptif_liste_ar, categorie_liste_ar, login_user)
    VALUES 
    (:old.id_list, :old.nom_liste, :old.descriptif_liste, :old.type_liste, :old.utilisateur_login_user);
    
    open c_appartient_liste;
    LOOP
        fetch c_appartient_liste into v_appartient_liste;
        exit when c_appartient_liste%NOTFOUND;
        INSERT INTO appartient_a_archive
        (id_objet, id_liste_ar, descriptif_objet_liste_ar)
        VALUES 
        (v_appartient_liste.objet_id_objet, v_appartient_liste.liste_objets_id_list, v_appartient_liste.descriptif_objet);
    
    END LOOP;
    close c_appartient_liste;
    
    DELETE FROM appartient_liste where liste_objets_id_list = :old.id_list;
    
END;
/




