@triggers

-- Test t_appartient_liste
INSERT INTO liste(id_list, nom_liste, date_creation, type_liste, utilisateur_login_user) 
VALUES(200, 'Meilleurs jeux ', SYSDATE, 'jeu video', 'Owhinter66');
INSERT INTO liste(id_list, nom_liste, date_creation, type_liste, utilisateur_login_user) 
VALUES(201, 'Films romantiques', SYSDATE, 'film', 'Owhinter66');
INSERT INTO objet VALUES(500, 'Tekken 2', 'film');

INSERT INTO appartient_liste(objet_id_objet, liste_objets_id_list, descriptif_objet) VALUES (500, 200, ' film sur le jeu video incroyable'); 
--produit une erreur(objet de type film, liste de type jeu video

INSERT INTO appartient_liste(objet_id_objet, liste_objets_id_list, descriptif_objet) VALUES (500, 201, 'film sur le jeu video incroyable');

-- Test t_login
INSERT INTO utilisateur VALUES('RCarpent99', 'Carpenter', 'Ronald', '48 boulevard de la Liberte, Lyon', '1-04-89', SYSDATE, 'Pua_Paoakalani_',13011); 
-- passe pas car partie du login correspondant au nom pas en minuscule

INSERT INTO utilisateur VALUES('Rcarpent99', 'Carpenter', 'Ronald', '48 boulevard de la Liberte, Lyon', '1-04-89', SYSDATE, 'Pua_Paoakalani_',13011);

-- Test t_liste_mois

insert into objet (id_objet, nom_objet, type_objet) values (31, 'kmccaughan0', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (32, 'gdolan1', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (33, 'ashepcutt2', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (34, 'cswallow3', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (35, 'adanne4', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (36, 'qmoneypenny5', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (37, 'lnockolds6', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (38, 'msommerville7', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (39, 'upeert8', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (40, 'mdayes9', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (41, 'rcoulmana', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (42, 'pstanyforthb', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (43, 'ctorrc', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (44, 'mgoundsyd', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (45, 'esomertone', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (46, 'hfabbf', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (47, 'bbelkg', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (48, 'dshellumh', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (49, 'kbalkei', 'livre');
insert into objet (id_objet, nom_objet, type_objet) values (51, 'cgwynethj', 'film');

select * from liste;
select * from appartient_liste;
-- les objets sont dans la liste du mois en cours

-- Test archivage 

INSERT INTO liste(id_list, nom_liste, date_creation, type_liste, utilisateur_login_user) 
VALUES(202, 'Chefs-d-oeuvre de la litterature francaise', SYSDATE, 'livre', 'Owhinter66');

insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (31, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (32, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (33, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (34, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (35, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (36, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (37, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (38, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (39, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (40, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (41, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (42, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (43, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (44, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (45, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (46, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (47, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (48, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (49, 202);
insert into appartient_liste (objet_id_objet, liste_objets_id_list) values (50, 202);

delete from liste where id_list = 2;
select * from liste;
select * from appartient_liste;
select * FROM LISTE_ARCHIVEE;
select * from appartient_a_archive;

