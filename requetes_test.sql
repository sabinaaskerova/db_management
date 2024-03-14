@droptables
@creation
@sequences
@plsql

INSERT INTO utilisateur VALUES('Owhinter66', 'Whinter', 'Owen', '90 rue Sadi Carnot, Auch', '11-12-66', SYSDATE, 'ALOhaOe_', 32000);
INSERT INTO utilisateur VALUES('Mrobinso72', 'Robinson', 'Matthew', '13 rue des Nations Unies, Saint-brieuc', '28-09-72', SYSDATE, 'Kamakani_B', 22000);
INSERT INTO utilisateur VALUES('Apearson82', 'Pearson', 'Anne', '5 rue du Faubourg National, Thionville', '29-01-82', SYSDATE, '_maui_beach', 57100);
INSERT INTO utilisateur VALUES('Groberts95', 'Robertson', 'Gloria', '45 rue Petite Fusterie, Boulogne-sur-mer', '12-08-95', SYSDATE, 'O_Makalapua_', 62200);
INSERT INTO utilisateur VALUES('Dcliffor00', 'Clifford', 'Daron', '48 boulevard de la Liberation, Marseille', '19-04-00', SYSDATE, 'Pua_Paoakalani_',13011);

INSERT INTO objet VALUES(1, 'Le Fabuleux Destin d''Amelie Poulain', 'film');
INSERT INTO objet VALUES(2, 'Leon', 'film');
INSERT INTO objet VALUES(3, 'Wasabi', 'film');
INSERT INTO objet VALUES(4, 'Pleasing The North', 'livre');
INSERT INTO objet VALUES(5, 'Voyage au bout de la nuit', 'livre');
INSERT INTO objet VALUES(6, 'Le Comte de Monte-Cristo', 'livre');

INSERT INTO objet VALUES(7, 'The Legend of Zelda', 'jeu video');
INSERT INTO objet VALUES(8, 'Super Mario Odyssey', 'jeu video');
INSERT INTO objet VALUES(9, 'Tekken', 'jeu video');
INSERT INTO objet VALUES(10, 'Tekken', 'film');
INSERT INTO objet VALUES(11, 'Shal', 'film');
INSERT INTO objet VALUES(12, 'Burn The Stage', 'livre');

-- 1. 'Owhinter66' l'utilisateur qui a crée une liste pour chaque type d'objet: livre, jeu video, film

INSERT INTO liste(id_list, nom_liste, date_creation, type_liste, utilisateur_login_user) 
VALUES(idListe_seq.nextval, 'Chefs-d-oeuvre de la litterature francaise', SYSDATE, 'livre', 'Owhinter66');
INSERT INTO liste(id_list, nom_liste, date_creation, type_liste, utilisateur_login_user) 
VALUES(idListe_seq.nextval, 'Meilleurs jeux des 2000s', SYSDATE, 'jeu video', 'Owhinter66');
INSERT INTO liste(id_list, nom_liste, date_creation, type_liste, utilisateur_login_user) 
VALUES(idListe_seq.nextval, 'Films ettonants', SYSDATE, 'film', 'Owhinter66');
INSERT INTO liste(id_list, nom_liste, date_creation, type_liste, utilisateur_login_user) 
VALUES(idListe_seq.nextval, 'Films emotifs', SYSDATE, 'film', 'Owhinter66');


-- 2.

INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (3, 'Dcliffor00');
INSERT INTO avis(note, id_objet, login_user) VALUES (16, 3, 'Dcliffor00');
INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (3, 'Mrobinso72'); 
INSERT INTO avis(note, id_objet, login_user) VALUES (20, 3, 'Mrobinso72'); 

INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (2, 'Dcliffor00');
INSERT INTO avis(note, id_objet, login_user) VALUES (10, 2, 'Dcliffor00');
INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (2, 'Mrobinso72'); 
INSERT INTO avis(note, id_objet, login_user) VALUES (5, 2, 'Mrobinso72'); 

CREATE OR REPLACE PROCEDURE creer_21_liste
is
begin
    FOR k IN idListe_seq.currval..28 LOOP
        INSERT INTO liste(id_list, nom_liste, date_creation, type_liste, utilisateur_login_user) 
        VALUES(idListe_seq.nextval, 'Collection test films', SYSDATE, 'film', 'Apearson82');
    end loop;

end;
/
CREATE OR REPLACE PROCEDURE test_req_2(
    id_objet objet.id_objet%TYPE)
IS
begin
    FOR k IN 7..28 LOOP
        INSERT INTO appartient_liste(objet_id_objet, liste_objets_id_list) 
        VALUES (id_objet, k);
    end loop;

end;
/
call creer_21_liste();
call test_req_2(3);
call test_req_2(2);

-- 3.
-- l'utilisateur 'Mrobinso72' ne sera pas affiché 
INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (12, 'Mrobinso72'); 
INSERT INTO avis(note, id_objet, login_user) VALUES (6, 12, 'Mrobinso72');


INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (7, 'Apearson82');
INSERT INTO avis(note, id_objet, login_user) VALUES (10, 7, 'Apearson82');

--4. 

INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (6, 'Mrobinso72');
INSERT INTO avis(note,id_objet,login_user, commentaire ) VALUES (15, 6, 'Mrobinso72', 'je n''aime pas cette histoire'); 
INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (12, 'Groberts95');
INSERT INTO avis(note,id_objet,login_user, commentaire) VALUES (10, 12, 'Groberts95', 'c''est moyen');
INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (12, 'Apearson82');
INSERT INTO avis(note, id_objet, login_user, commentaire) VALUES (20, 12, 'Apearson82', 'une histoire incroyable');
-- l'objet le plus commenté sera l'objet 12

INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (4, 'Groberts95');
INSERT INTO avis(note,id_objet,login_user, commentaire) VALUES (10, 4, 'Groberts95', 'c''est moyen');
INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (4, 'Dcliffor00');
INSERT INTO avis(note,id_objet,login_user, commentaire) VALUES (15, 4, 'Dcliffor00', 'c''est moyen');
INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (4, 'Owhinter66');
INSERT INTO avis(note,id_objet,login_user, commentaire) VALUES (8, 4, 'Owhinter66', 'je n''ai pas apprecie');
-- l'objet le plus commenté sera l'objet 4

-- 5.

INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (10, 'Apearson82');
INSERT INTO avis(note, id_objet, login_user, commentaire, date_avis) VALUES (15, 10, 'Apearson82', 'film a propos du jeu video legendaire', '07/07/21');

INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (5, 'Apearson82');
INSERT INTO avis(note, id_objet, login_user, date_avis) VALUES (13, 5, 'Apearson82', '20/08/21');

INSERT INTO achat(objet_id_objet, utilisateur_login_user) VALUES (8, 'Apearson82');
INSERT INTO avis(note, id_objet, login_user, date_avis) VALUES (19, 8, 'Apearson82', '15/09/21');


INSERT INTO objet VALUES (13, 'Demolition 2', 'film');
INSERT INTO objet VALUES (14, '1985', 'livre');
INSERT INTO objet VALUES (15, 'Animal Farm 2', 'livre');
INSERT INTO objet VALUES (16, 'Harry Potter 5', 'livre');

INSERT INTO objet VALUES (17, 'Ori and the Blind Forest Again', 'jeu video');
INSERT INTO objet VALUES (18, 'Hollow Knight 3', 'jeu video');
INSERT INTO objet VALUES (19, 'Overwatch 4', 'jeu video');
INSERT INTO objet VALUES (20, 'Fortnit', 'jeu video');
INSERT INTO objet VALUES (21, 'Pokemon Go', 'jeu video');

INSERT INTO avis VALUES (1,'Apearson82', 10, 'Amelie Poulain', '15-03-21');
INSERT INTO avis VALUES (2, 'Apearson82', 3, 'Leon', SYSDATE);
INSERT INTO avis VALUES (3, 'Apearson82',17, 'Wasabi', SYSDATE);
INSERT INTO avis VALUES (13, 'Apearson82', 19, 'Demolition', '15-04-21');

INSERT INTO avis VALUES (6, 'Apearson82', 15, 'Monte Cristo', SYSDATE);
INSERT INTO avis VALUES (14, 'Apearson82', 20, '1984', '15-05-21');
INSERT INTO avis VALUES (15, 'Apearson82', 18, 'Animal Farm', SYSDATE);
INSERT INTO avis VALUES (16, 'Apearson82', 17, 'Harry Potter', SYSDATE);


INSERT INTO avis VALUES (17, 'Groberts95', 20, 'Ori', '15-08-22');
INSERT INTO avis VALUES (18, 'Apearson82', 17, 'Hollow Knight', SYSDATE);
INSERT INTO avis VALUES (19, 'Groberts95', 14, 'Overwatch', '15-09-22');
INSERT INTO avis VALUES (20, 'Apearson82', 7, 'Fortnite', SYSDATE);
INSERT INTO avis VALUES (21, 'Groberts95', 10, 'Pokemon', '15-07-22');
INSERT INTO avis VALUES (9, 'Apearson82', 10, 'Tekken', SYSDATE);

INSERT INTO avis VALUES (12, 'Owhinter66', 5, 'Burn the Stage', SYSDATE);
INSERT INTO avis VALUES (1,'Owhinter66', 10, 'Amelie Poulain', '15-03-22');
INSERT INTO avis VALUES (2, 'Owhinter66', 3, 'Leon', SYSDATE);
INSERT INTO avis VALUES (10, 'Owhinter66', 15, 'Tekken', SYSDATE);
INSERT INTO avis VALUES (3, 'Owhinter66',17, 'Wasabi', SYSDATE);
INSERT INTO avis VALUES (13, 'Owhinter66', 19, 'Demolition', '15-04-22');

INSERT INTO avis VALUES (6, 'Owhinter66', 15, 'Monte Cristo', SYSDATE);
INSERT INTO avis VALUES (5, 'Owhinter66', 7, 'Voyage au bout de la nuit', SYSDATE);
INSERT INTO avis VALUES (14, 'Owhinter66', 20, '1984', '15-05-22');
INSERT INTO avis VALUES (15, 'Owhinter66', 18, 'Animal Farm', SYSDATE);
INSERT INTO avis VALUES (16, 'Owhinter66', 17, 'Harry Potter', SYSDATE);

INSERT INTO avis VALUES (17, 'Owhinter66', 20, 'Ori', '15-08-22');
INSERT INTO avis VALUES (18, 'Owhinter66', 17, 'Hollow Knight', SYSDATE);
INSERT INTO avis VALUES (19, 'Apearson82', 14, 'Overwatch', '15-09-22');
INSERT INTO avis VALUES (20, 'Owhinter66', 7, 'Fortnite', SYSDATE);
INSERT INTO avis VALUES (21, 'Owhinter66', 10, 'Pokemon', '15-07-22');
INSERT INTO avis VALUES (9, 'Owhinter66', 10, 'Tekken', SYSDATE);
INSERT INTO avis VALUES (7, 'Owhinter66', 13, 'Zelda', SYSDATE);

commit;