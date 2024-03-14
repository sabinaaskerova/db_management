DROP TABLE avis CASCADE CONSTRAINTS;
DROP TABLE appartient_liste CASCADE CONSTRAINTS;
DROP TABLE APPARTIENT_A_ARCHIVE CASCADE CONSTRAINTS;
DROP TABLE achat CASCADE CONSTRAINTS;
DROP TABLE desir_achat CASCADE CONSTRAINTS;
DROP TABLE liste CASCADE CONSTRAINTS;
DROP TABLE LISTE_ARCHIVEE CASCADE CONSTRAINTS;
DROP TABLE objet CASCADE CONSTRAINTS;

DROP TABLE utilisateur CASCADE CONSTRAINTS;


CREATE TABLE achat (
    objet_id_objet          NUMBER(6) ,
    utilisateur_login_user  VARCHAR2(10) ,
    date_achat              TIMESTAMP DEFAULT SYSTIMESTAMP
);

ALTER TABLE achat ADD CONSTRAINT objet_liste_utilisateur_pk PRIMARY KEY ( objet_id_objet,
                                                                          utilisateur_login_user,
                                                                          date_achat);

CREATE TABLE avis (
  id_objet NUMBER,
  login_user VARCHAR2(10),
  note NUMBER,
  commentaire VARCHAR(1024),
  date_avis TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT PK_AVIS PRIMARY KEY (id_objet, login_user)
);

ALTER TABLE avis ADD CONSTRAINT note_0_20 CHECK (note BETWEEN 0 AND 20);

CREATE TABLE appartient_liste (
    objet_id_objet        NUMBER(6),
    liste_objets_id_list  NUMBER(6),
    descriptif_objet      VARCHAR2(512),
    date_ajout            DATE DEFAULT SYSDATE NOT NULL
);

ALTER TABLE appartient_liste ADD CONSTRAINT appartient_objet_liste_pk PRIMARY KEY ( objet_id_objet,
                                                                                    liste_objets_id_list );

CREATE TABLE APPARTIENT_A_ARCHIVE (
  id_objet NUMBER,
  id_liste_ar NUMBER,
  descriptif_objet_liste_ar VARCHAR(1024),
  CONSTRAINT PK_APPARTIENT_A_ARCHIVE PRIMARY KEY (id_objet, id_liste_ar)
);

CREATE TABLE LISTE_ARCHIVEE (
  id_liste_ar NUMBER,
  nom_liste_ar VARCHAR(256) NOT NULL,
  descriptif_liste_ar VARCHAR(512),
  categorie_liste_ar VARCHAR(64) NOT NULL,
  date_archivage TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  login_user VARCHAR2(10) NOT NULL,
  CONSTRAINT PK_APPARTIENT_LISTE_ARCHIVEE PRIMARY KEY (id_liste_ar)
);

CREATE TABLE desir_achat (
    objet_id_objet          NUMBER(6),
    utilisateur_login_user  VARCHAR2(10)
);

ALTER TABLE desir_achat ADD CONSTRAINT desir_achat_pk PRIMARY KEY ( utilisateur_login_user,
                                                                    objet_id_objet );

CREATE TABLE liste (
    id_list                 NUMBER(6),
    nom_liste               VARCHAR2(256) NOT NULL,
    date_creation           DATE DEFAULT SYSDATE NOT NULL,
    descriptif_liste        VARCHAR2(512),
    type_liste              VARCHAR2(256), -- cf trigger t_user pour les contraintes 'non-vide'
    utilisateur_login_user  VARCHAR2(10) NOT NULL
);

ALTER TABLE liste ADD CONSTRAINT liste_objets_pk PRIMARY KEY ( id_list );

CREATE TABLE objet (
    id_objet    NUMBER(6),
    nom_objet   VARCHAR2(256) NOT NULL,
    type_objet  VARCHAR2(256) NOT NULL
);

ALTER TABLE objet ADD CONSTRAINT objet_pk PRIMARY KEY ( id_objet );

ALTER TABLE objet ADD CONSTRAINT objet_unique UNIQUE ( nom_objet, type_objet );

CREATE TABLE utilisateur (
    login_user        VARCHAR2(10),
    nom_user          VARCHAR2(256), -- cf trigger t_user pour les contraintes 'non-vide'
    prenom_user       VARCHAR2(256),-- cf trigger t_user pour les contraintes 'non-vide'
    adresse_user      VARCHAR2(100),
    naissance_user    DATE,-- cf trigger t_user pour les contraintes 'non-vide'
    inscription_user  DATE DEFAULT SYSDATE NOT NULL,
    mdp_user          VARCHAR2(100),-- cf trigger t_user pour les contraintes 'non-vide'
    code_postal       NUMBER(5)
);

ALTER TABLE utilisateur ADD CONSTRAINT utilisateur_pk PRIMARY KEY ( login_user );

ALTER TABLE utilisateur ADD CONSTRAINT mdp_format CHECK (REGEXP_LIKE(mdp_user, '^[a-zA-Z0-9_]+$'));

ALTER TABLE achat
    ADD CONSTRAINT achat_objet_fk FOREIGN KEY ( objet_id_objet )
        REFERENCES objet ( id_objet );

ALTER TABLE achat
    ADD CONSTRAINT achat_utilisateur_fk FOREIGN KEY ( utilisateur_login_user )
        REFERENCES utilisateur ( login_user );

ALTER TABLE appartient_liste
    ADD CONSTRAINT appartient_liste_liste_fk FOREIGN KEY ( liste_objets_id_list )
        REFERENCES liste ( id_list );

ALTER TABLE appartient_liste
    ADD CONSTRAINT appartient_liste_objet_fk FOREIGN KEY ( objet_id_objet )
        REFERENCES objet ( id_objet );

ALTER TABLE desir_achat
    ADD CONSTRAINT desir_achat_objet_fk FOREIGN KEY ( objet_id_objet )
        REFERENCES objet ( id_objet );

ALTER TABLE desir_achat
    ADD CONSTRAINT desir_achat_utilisateur_fk FOREIGN KEY ( utilisateur_login_user )
        REFERENCES utilisateur ( login_user );

ALTER TABLE liste
    ADD CONSTRAINT liste_utilisateur_fk FOREIGN KEY ( utilisateur_login_user )
        REFERENCES utilisateur ( login_user );

ALTER TABLE avis 
    ADD CONSTRAINT avis_login_user_fk FOREIGN KEY (login_user) 
        REFERENCES utilisateur ( login_user );

ALTER TABLE avis 
    ADD CONSTRAINT avis_id_objet_fk FOREIGN KEY (id_objet) 
        REFERENCES objet ( id_objet );
