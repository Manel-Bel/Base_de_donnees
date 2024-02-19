-- 1.1
SELECT * FROM tournois ;
SELECT * FROM matchs ;
SELECT * FROM participation ;
SELECT * FROM equipes ;
-- 1.2
SELECT annee FROM tournois WHERE pays = 'Nouvelle-Zélande' AND nom = 'Coupe du Monde' ;
-- π(annee)(σ(pays = 'Nouvelle-Zélande' && nom = 'Coupe du Monde') tournois)
-- 1.3
SELECT pays FROM equipes WHERE nom = 'XV de France' ;
-- π(pays)(σ(nom = 'XV de France') equipes)
-- 1.4
SELECT DISTINCT gagnant FROM matchs;
-- π(gagnant)(matchs)


-- 2.1
SELECT DISTINCT e.nom FROM equipes e JOIN matchs m ON e.eid = m.gagnant ;
-- π(nom)((π(gagnant)(matchs) ⋈ equipes))

-- 2.2
SELECT t.nom, t.annee FROM tournois t JOIN matchs m ON t.tid = m.tournois WHERE m.perdant = 2 ; 
-- π(nom, annee) ( (σ(perdant=2)(matchs)) ⋈ tournois )

-- 2.3
SELECT m.mid FROM matchs m JOIN equipes e ON m.perdant = e.eid AND e.nom = 'Wallabies';
-- π(mid) ( (π(eid)σ(nom='Wallabies')(equipes)) ⋈ matchs )
--                                        eid == m.perdant

-- 2.4
SELECT m.mid FROM matchs m JOIN equipes e ON (m.perdant = e.eid OR m.gagnant = e.eid) AND e.nom = 'All Blacks'; 
-- π(mid) ((π(eid)σ(nom='All Blacks')(equipes))  ⋈ π(gagnant, perdant) matchs)

-- 2.5
SELECT e.eid FROM equipes e JOIN participation p ON e.eid = p.eid WHERE p.tid =(SELECT t.tid FROM tournois t WHERE t.nom = 'Coupe du Monde' AND t.annee = 1991 ) ;

-- 3.1 
SELECT e.nom FROM tournois t JOIN participation p ON t.tid = p.tid JOIN equipes e ON e.eid = p.eid WHERE t.annee = 1991 ;
-- SELECT e.nom FROM equipes e JOIN participation p ON e.eid = p.eid AND p.tid = (SELECT t.tid FROM tournois t WHERE t.nom = 'Coupe du Monde' AND t.annee = 1991 ) ;

-- π(equipe.nom) (π(tid)(σ(t.annee == 1991)tournois) ⨝ 
--                                              p.tid=t.tid
-- participation  ⨝ equipes)
--          p.eid= e.eid

-- 3.2
SELECT t.nom , t.annee FROM equipes e JOIN matchs m ON ( e.eid = m.perdant AND  e.nom = 'XV de France' ) JOIN tournois t ON m.tournois = t.tid ;

-- 3.3
SELECT e.nom, t.annee FROM tournois t JOIN matchs m ON ( t.tid = m.tournois AND t.nom = 'Coupe du Monde' AND m.tour = 'finale' ) JOIN equipes e ON e.eid = m.gagnant ;

-- 3.4
SELECT DISTINCT e.nom FROM equipes e JOIN matchs m ON m.perdant = e.eid WHERE e.eid IN (SELECT e1.eid FROM equipes e1 JOIN matchs m1 ON m1.gagnant = e1.eid AND m.tournois = 
m1.tournois )
-- SELECT DISTINCT e.nom FROM matchs m JOIN matchs m1 ON ( m.tournois = m1.tournois AND m.perdant = m1.gagnant ) JOIN equipes e ON e.eid = m.gagnant OR e.eid = m.perdant ;

-- 3.5 ??
SELECT DISTINCT e.nom FROM matchs m JOIN matchs m1 ON ( m.mid <> m1.mid AND m.tour = 'finale' AND m1.tour = 'finale' AND (m.gagnant = m1.gagnant OR m.gagnant = m1.perdant OR m.perdant = m1.gagnant OR m.perdant = m1.perdant ) ) JOIN equipes e ON (e.eid = m.gagnant OR e.eid = m.perdant) ;

-- 4.1
SELECT e.nom , e.pays FROM equipes e WHERE e.pays NOT IN (SELECT pays FROM tournois WHERE nom= 'Coupe du Monde' ) ;

-- 4.2
SELECT nom FROM equipes WHERE eid NOT IN  (SELECT e.eid FROM equipes e JOIN matchs m ON m.tour = 'finale' AND (e.eid = m.gagnant OR e.eid = m.perdant)) ;

-- 4.3
SELECT t.nom , t.annee FROM tournois t WHERE t.tid IN ( (SELECT m.tournois FROM matchs m JOIN equipes e ON ( e.nom = 'XV de France' AND e.eid = m.perdant)) EXCEPT (SELECT m.tournois FROM matchs m JOIN equipes e ON ( e.nom = 'XV de France' AND e.eid = m.gagnant)) ) ;

-- 4.4
SELECT nom FROM equipes WHERE eid NOT IN (SELECT DISTINCT m.perdant FROM matchs m EXCEPT (SELECT DISTINCT m.gagnant FROM matchs m) ) ;

-- 4.5
SELECT nom FROM equipes WHERE eid NOT IN (SELECT eid FROM participation ) ;

-- 4.6
SELECT t.nom, t.annee FROM tournois t WHERE t.tid NOT IN (SELECT DISTINCT tournois FROM matchs) ;

-- 5.1 
DELETE FROM tournois WHERE tid NOT IN (SELECT DISTINCT tournois FROM matchs ) ;

-- 5.2 
DELETE FROM equipes WHERE eid NOT IN (SELECT DISTINCT eid FROM participation ) ; 

-- 5.3
