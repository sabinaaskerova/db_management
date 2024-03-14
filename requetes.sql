-- 1.
-- version à utiliser
select utilisateur_login_user from liste
group by utilisateur_login_user
having count(distinct type_liste) >= 
(select count(distinct type_objet) from objet);

-- version desimbriquée non optimale, à éviter
SELECT L.utilisateur_login_user FROM liste L, objet o
GROUP BY L.utilisateur_login_user
HAVING COUNT(DISTINCT L.type_liste) >= COUNT(DISTINCT o.type_objet);


-- 2.
select id_objet from objet
where id_objet in
(select objet_id_objet from appartient_liste having count(*) > 20 group by objet_id_objet
intersect
select id_objet from avis having avg(note) >14 group by id_objet)
group by id_objet;

-- version desimbriquée non optimale, à éviter
SELECT o.id_objet FROM objet o
INNER JOIN appartient_liste A
ON o.id_objet = A.objet_id_objet
INNER JOIN avis av
ON o.id_objet = av.id_objet
GROUP BY o.id_objet
HAVING COUNT(*) > 20
AND AVG(av.note) >14;

-- 3.
select login_user from utilisateur
where login_user not in 
(select login_user from avis where note < 8);



-- 4.
-- à éviter
select id_objet, count(commentaire) from avis
having count(commentaire) = 
    (select max(count(*)) from avis
    where commentaire is not null 
    and date_avis BETWEEN SYSDATE-7 AND SYSDATE
    group by id_objet)
group by id_objet;

-- version desimbriquée, plus optimisée
select id_objet, count(commentaire) from avis
where commentaire is not null 
and date_avis BETWEEN SYSDATE-7 AND SYSDATE
group by id_objet
ORDER BY count(commentaire) DESC
FETCH FIRST 1 ROWS ONLY;

-- optimisation avec index

drop index indx_comment;
create index indx_comment on avis('x'|| commentaire);

select id_objet, count(commentaire) from avis
where 'x' || commentaire <>'x' 
and date_avis BETWEEN SYSDATE-7 AND SYSDATE
group by id_objet
ORDER BY count(commentaire) DESC
FETCH FIRST 1 ROWS ONLY;

-- 5.

with user_3_month as 
(SELECT DISTINCT a.login_user 
FROM avis a
--Triple jointure où on ajoute un mois à chaque fois et où on vérifie que c'est
--bien la même année
JOIN avis b ON a.login_user = b.login_user
AND EXTRACT(MONTH FROM b.date_avis) = EXTRACT(MONTH FROM a.date_avis) + 1
AND EXTRACT(YEAR FROM b.date_avis) = EXTRACT(YEAR FROM a.date_avis)
JOIN avis c ON b.login_user = c.login_user
AND EXTRACT(MONTH FROM c.date_avis) = EXTRACT(MONTH FROM b.date_avis) + 1
AND EXTRACT(YEAR FROM c.date_avis) = EXTRACT(YEAR FROM b.date_avis)
--On vérifie que c'est sur l'année précédente
WHERE EXTRACT(YEAR FROM a.date_avis) = EXTRACT(YEAR FROM SYSDATE) - 1)
SELECT login, count(DISTINCT a.objet_id_objet) as nb_possedes, count(DISTINCT da.objet_id_objet) as nb_a_acheter,
NVL(min(longueur),0) as min_longueur, NVL(max(longueur),0) as max_longueur, NVL(avg(longueur),0) as avg_longueur
FROM (SELECT u.login_user as login, l.id_list, count(DISTINCT appa.objet_id_objet) as longueur 
    FROM user_3_month u
    LEFT OUTER JOIN liste l ON u.login_user = l.utilisateur_login_user
    LEFT OUTER JOIN appartient_liste appa ON l.id_list = appa.liste_objets_id_list   
    GROUP BY u.login_user, l.id_list)
LEFT OUTER JOIN achat a ON a.utilisateur_login_user = login
LEFT OUTER JOIN desir_achat da ON da.utilisateur_login_user = login
GROUP BY login;