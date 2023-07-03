-- Active: 1663786901850@@127.0.0.1@5432@tp_note
-- votre nom: LI
-- votre prenom: Junji

-- test;
SELECT * FROM featureclass;

-- 1.
SELECT fc.description, cc.name as ctname, COUNT(*) as nb
FROM geoitem g
    LEFT JOIN feature f on f.code = g.feature_code
    LEFT JOIN featureclass fc on f.class = fc.code
    LEFT JOIN country c on c.iso = g.country_code
    LEFT JOIN continent cc on c.continent = cc.code
GROUP BY ctname, fc.description
ORDER BY nb DESC;

-- 2.
SELECT cc.name as continent, c.country, g.asciiname as geoitem, count(*) as nb, 
    max(g.elevation) as elevation_max
FROM geoitem g
    LEFT JOIN country c on c.iso = g.country_code
    LEFT JOIN continent cc on c.continent = cc.code
WHERE g.elevation >= 1000
GROUP BY ROLLUP(cc.name, c.country, geoitem)
ORDER BY nb ASC
;

-- 3.
SELECT g.asciiname, g.elevation, dense_rank() OVER (ORDER BY g.elevation DESC) as rang
FROM geoitem g
WHERE g.elevation IS NOT NULL
ORDER BY elevation DESC, rang ASC
;


-- 4.
WITH t AS (
    SELECT c.country, g.asciiname, g.pop, ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY g.pop DESC) as rn
    FROM geoitem g
        LEFT JOIN country c on c.iso = g.country_code
    
)
SELECT t.country, t.asciiname, t.pop
FROM t
WHERE t.rn <= 10
ORDER BY t.country ASC, t.pop DESC
;

-- 5.
-- (a)
SELECT v.depart
FROM voyage v
    LEFT JOIN geoitem g on g.geonameid = v.depart
WHERE v.depart NOT IN (SELECT destination FROM voyage)
    AND personne = 'Durand'
;
-- (b)
WITH RECURSIVE ta AS (
    -- init
    SELECT v.destination, v.nb_j, 1 nb_etape
    FROM voyage v
        LEFT JOIN geoitem g on g.geonameid = v.depart
    WHERE v.depart NOT IN (SELECT destination FROM voyage)
        AND personne = 'Durand'
    UNION ALL
    -- rec
    SELECT v2.destination as dest, v2.nb_j + ta.nb_j, nb_etape + 1
    FROM voyage v2, ta
    WHERE v2.depart = ta.destination
)
SELECT *
FROM ta
;

-- (c)
WITH RECURSIVE ta AS (
    -- init
    SELECT v.destination, v.nb_j, 1 nb_etapes
    FROM voyage v
    WHERE v.depart NOT IN (SELECT destination FROM voyage)
        AND personne = 'Durand'
    UNION ALL
    -- rec
    SELECT v2.destination as dest, v2.nb_j + ta.nb_j, nb_etapes + 1
    FROM voyage v2, ta
    WHERE v2.depart = ta.destination
)
SELECT g.asciiname, ta.nb_j, ta.nb_etapes
FROM ta, geoitem g
WHERE ta.destination = g.geonameid
;