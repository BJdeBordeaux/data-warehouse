-- votre nom: LI
-- votre prenom: Junji

-- Q1
SELECT f.description,
    cc.name as ctname,
    count(*) as nb
FROM country c, continent cc, geoitem g, feature f, featureclass fc
WHERE g.country_code = c.iso 
    AND c.continent = cc.code
    AND g.feature_code = f.code 
    AND f.class = fc.code
    AND f.description is NOT NULL
GROUP BY ctname, f.description
ORDER BY nb DESC;

/* 0 result : check join condition. If Ok, retry/rewrite */


-- Q2
SELECT cc.name continent, c.country, g.asciiname geoitem, COUNT(*) as nb, MAX(elevation) elevation_max
FROM continent cc, country c, geoitem g
WHERE cc.code = c.continent 
    AND c.iso = g.country_code
    AND elevation >= 1000
GROUP BY ROLLUP(cc.name, c.country, geoitem)
ORDER BY nb ASC;

/* Alias in `SELECT` can be used in `GROUP BY` and `ORDER BY`, but not in following aggregate function */


-- Q3
SELECT g.asciiname, g.elevation, DENSE_RANK() OVER (ORDER BY g.elevation DESC)  as rank
FROM geoitem g
WHERE g.elevation IS NOT NULL
ORDER BY rank;

-- Q4
WITH tab AS (
SELECT c.country, g.asciiname, g.pop, ROW_NUMBER() OVER (PARTITION BY g.country_code ORDER BY g.pop DESC)  as rank
FROM geoitem g INNER JOIN country c ON g.country_code = c.iso
ORDER BY c.country, rank
)
SELECT country, asciiname, pop --, ROW_NUMBER() OVER ()
FROM tab
WHERE rank <= 10
ORDER BY country, pop DESC;

/* Here, not RANK-like function but `ROW_NUMBER()` can limite the display results */

-- Q5 a
SELECT v.depart
FROM voyage v, geoitem g
WHERE v.depart = g.geonameid
    AND v.personne = 'Durand'
    AND v.depart NOT IN 
(
    SELECT v2.destination
    FROM voyage v2
    WHERE v2.personne = 'Durand'
);


-- Q5b
WITH RECURSIVE tab AS(
    -- initialisation
    SELECT destination dest, nb_j , 1 nb_etapes
    FROM voyage 
    WHERE depart IN (
        SELECT v.depart
        FROM voyage v, geoitem g
        WHERE v.depart = g.geonameid
            AND v.personne = 'Durand'
            AND v.depart NOT IN 
        (
            SELECT v2.destination
            FROM voyage v2
            WHERE v2.personne = 'Durand'
        )
    )
    UNION ALL
    -- récursion
    SELECT destination dest, tab.nb_j + v.nb_j, nb_etapes + 1
    FROM voyage v, tab
    WHERE v.depart = tab.dest
        AND v.personne = 'Durand'
)
SELECT dest, nb_j, nb_etapes
FROM tab;


-- Q5c
WITH RECURSIVE tab AS(
    -- initialisation
    SELECT destination dest, nb_j , 1 nb_etapes
    FROM voyage 
    WHERE depart IN (
        SELECT v.depart
        FROM voyage v, geoitem g
        WHERE v.depart = g.geonameid
            AND v.personne = 'Durand'
            AND v.depart NOT IN 
        (
            SELECT v2.destination
            FROM voyage v2
            WHERE v2.personne = 'Durand'
        )
    )
    UNION ALL
    -- récursion
    SELECT destination dest, tab.nb_j + v.nb_j, nb_etapes + 1
    FROM voyage v, tab
    WHERE v.depart = tab.dest
        AND v.personne = 'Durand'
)
SELECT g.asciiname, nb_j, nb_etapes
FROM tab, geoitem g
WHERE tab.dest = g.geonameid;


/*
Partie regex:


Q1:
La 1er expression matche toute la chaîne 'aaacc'. Car le symbole '*' est glouton par défaut, il va matcher jusqu'à 'aa', il reste 'ac' pour `(b|ac)+` et 'c' pour `c`.
La 2e matche toute la chaîne 'aaacc'. `*?` veut dire que ce match pour 'a' est paresseux, donc `a*?` match jusqu'à 'aa' et `(b|ac)*` match 'ac' et `c` match 'c'.
La 3e matche 'aaac'. `a*` match 'aaa' et (b|ac)* ne trouve pas de match, qui n'empêche que `c` match 'c' à la fin.

Q2:
regex_find = r'\$(.*?)\$'
motif_replace = r'stem:[\1]'

*/



