SET SERVEROUTPUT ON

-- 1. 

/**
* @brief Calcule la moyenne de toutes les notes sur l'œuvre
* @param id : id de l'objet
* @result : un flottant, la moyenne arithmétique des notes de cette œuvre
*/

CREATE OR REPLACE FUNCTION score_oeuvre(id objet.id_objet%TYPE)
RETURN FLOAT

IS
        cursor c_avis is
        select * from avis
        where id_objet = id
        and note is not null;
        v_avis c_avis%ROWTYPE; 

        nb_evaluations INTEGER := 0;
        score FLOAT;
        somme avis.note%TYPE;
BEGIN
       
        somme := 0;
        open c_avis;
        loop 
            fetch c_avis into v_avis;
            exit when c_avis%NOTFOUND;
            somme := somme + v_avis.note;
            nb_evaluations := nb_evaluations + 1;
            
        end loop;
        close c_avis;
        if nb_evaluations <= 20
        then return 0;
        else 
            score := somme / nb_evaluations;
            return score;
        end if;

END score_oeuvre;
/



-- 2. 

/**
* @brief Vérifie pour un type d'objet 'type' s'il y en a assez de notés (10) pour
* générer une liste, et si oui génère cette liste.
* 
* @param type : 'film', 'livre' ou 'jeu video'
* @user_login : l'utilisateur pour qui on veut créer cette liste
* @result : un message indiquant si la liste a pu être créée ou non
*/
CREATE OR REPLACE FUNCTION insert_fav_listes(type_ VARCHAR, user_login VARCHAR)
RETURN VARCHAR
IS
    --Curseur permettant de sélectionner les notes les plus hautes pour un type
    --donné en argument
    CURSOR cursor_type IS
        SELECT a.login_user, a.id_objet, a.note, o.nom_objet, o.type_objet
        FROM avis a, objet o
        WHERE o.type_objet = type_ and o.id_objet = a.id_objet and a.login_user = user_login
        ORDER BY a.note DESC;
    
    compteur INTEGER;
    indice_liste INTEGER;
    liste_cur_type cursor_type%ROWTYPE;
    mess VARCHAR(50);
BEGIN
    OPEN cursor_type;
    --On compte (et stocke dans la variable 'compteur') s'il y a assez de notes
    --pour générer une liste
    SELECT count(*) into compteur
    FROM avis a, objet o
    WHERE a.id_objet = o.id_objet AND o.type_objet = type_ AND a.login_user = user_login;
    
    --S'il y en a assez, on génère une nouvelle liste
    IF compteur >= 10
    THEN
        --Génération d'une liste de favoris de type dans la table 'liste'
        INSERT INTO liste VALUES (idListe_seq.nextval, type_ || ' favoris', SYSDATE, NULL, type_, user_login);
        indice_liste := idListe_seq.currval;
        --A chaque itération et grâce au curseur, on récupère la note la plus haute de ce type
        --et on l'insère dans la table 'appartient_liste' avec l'identifiant parent de la liste
        --qu'on vient de créer
        FOR k IN 1..10 LOOP
            FETCH cursor_type INTO liste_cur_type;
            INSERT INTO appartient_liste VALUES (liste_cur_type.id_objet, indice_liste, liste_cur_type.nom_objet || ' fav ' || type_, SYSDATE);
        END LOOP;
        --Message renvoyé
        mess := 'Insertion d''une liste de ' || type_ || ' effectuée';
    
    ELSE
        mess := 'Liste de ' || type_ || ' non suffisante : pas générée';
    END IF;
    CLOSE cursor_type;  
    RETURN mess;
END;
/

/**
* @brief Vérifie pour les 3 types 'film', 'livre', et 'jeu video' s'il y en a assez
* de notés pour en créer des listes de favoris, et les génèrent dans ce cas. Un message
* est affiché pour dire lesquelles ont pu l'être ou non.
* 
* @param user_login : l'utilisateur pour qui on veut créer cette liste
*/
CREATE OR REPLACE PROCEDURE favorites (user_login VARCHAR)
IS
    mess VARCHAR(50);
BEGIN
    --Génération (ou échec s'il n'y en a pas assez) de la liste des films favoris
    mess := insert_fav_listes('film', user_login);
    DBMS_OUTPUT.PUT_LINE(mess);
    
    --Génération (ou échec s'il n'y en a pas assez) de la liste des livres favoris
    mess := insert_fav_listes('livre', user_login);
    DBMS_OUTPUT.PUT_LINE(mess);
    
    --Génération (ou échec s'il n'y en a pas assez) de la liste des jeux vidéos favoris
    mess := insert_fav_listes('jeu video', user_login);
    DBMS_OUTPUT.PUT_LINE(mess);
END;
/

-- 3. 

CREATE OR REPLACE TYPE table_users AS TABLE OF VARCHAR2(20);
/
/**
* @brief Récupère dans une table custom Y utilisateurs ayant mis au moins Z
* même notes que l'utilisateur user_login
*
* @param user_login l'utilisateur pour lequel on voudra avoir des suggestions
* @param y le nombre d'utilisateurs en commun
* @param le nombre minimum de notes identiques avec l'utilisateur

* @return une table contenant les Y utilisateurs
*/
CREATE OR REPLACE FUNCTION y_utilisateurs_meme_note(user_login VARCHAR, y INTEGER, z INTEGER)
RETURN table_users
IS
    --On récupère grâce à ce cursor tous les utilisateurs autre que celui concerné
    --et le nombre de notes égales avec l'utilisateur concerné
    CURSOR cursor_users IS 
        SELECT DISTINCT a.login_user, count(a.note)as notes_egales
        FROM avis a
        JOIN avis b ON a.id_objet = b.id_objet AND b.login_user = 'Apearson82' 
        AND a.login_user != 'Apearson82' AND a.note = b.note
        GROUP BY a.login_user;
    
    avis_cur_users cursor_users%ROWTYPE;
    table_y table_users := table_users();
    i INTEGER := 1;
BEGIN
    OPEN cursor_users;
    table_y.EXTEND(y);
    FOR k in 1..y
    LOOP
        FETCH cursor_users INTO avis_cur_users;
        EXIT WHEN cursor_users%NOTFOUND;
        --Condition d'ajout dans la table : si on a moins Z notes en commun
        --et si on n'a pas encore Y utilisateurs dans la table
        IF avis_cur_users.notes_egales >= z AND i < y THEN
            table_y(i) := avis_cur_users.login_user;
            i := i+1;
        END IF;
    END LOOP;
    CLOSE cursor_users;
    RETURN table_y;
END;
/

/** @brief Affiche des suggestions d'objets pour l'utilisateur user_login
*
*   @param user_login l'utilisateur pour lequel on veut afficher des suggestions
*   @param x le nombre d'objet à afficher
*   @param y argument pour la fonction 'y_utilisateurs_meme_note'
*   @param z argument pour la fonction 'y_utilisateurs_meme_note'
*/
CREATE OR REPLACE PROCEDURE suggestions(user_login VARCHAR2, x NUMBER, y NUMBER, z NUMBER)
IS
    --On récupère notre table d'Y utilisateurs ayant mis Z mêmes notes que l'utilisateur user_login
    users_y table_users := y_utilisateurs_meme_note(user_login, y, z);
    
    CURSOR cursor_suggest IS
        SELECT id_objet, nom_objet, max(avg_note) as maximum
        --Récupération des notes moyennes où l'utilisateurs fait partie de la table
        --et où l'objet ne fait pas partie d'une liste de l'utilisateur user_login
        FROM (SELECT a.id_objet as objet_id, avg(a.note) as avg_note FROM avis a
            JOIN avis b ON b.login_user != user_login
            WHERE a.login_user MEMBER OF users_y
            AND a.id_objet NOT IN (SELECT appa.objet_id_objet FROM appartient_liste appa
                JOIN liste l ON appa.liste_objets_id_list = l.id_list AND l.utilisateur_login_user = user_login) 
            GROUP BY a.id_objet)
        JOIN objet o ON objet_id = o.id_objet
        GROUP BY id_objet, nom_objet
        ORDER BY maximum DESC;
    
    row_cur_suggest cursor_suggest%ROWTYPE;  
BEGIN
    DBMS_OUTPUT.PUT_LINE('Liste de suggestions pour l''utilisateur '||user_login||' :');
    OPEN cursor_suggest;
    FOR k in 1..x
    LOOP
        FETCH cursor_suggest INTO row_cur_suggest;
        EXIT WHEN cursor_suggest%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(k||'. Identifiant de l''objet : '||row_cur_suggest.id_objet||
        ', nom : '||row_cur_suggest.nom_objet||
        ', score moyen : '||row_cur_suggest.maximum);
    END LOOP;
    CLOSE cursor_suggest;
END;
/


