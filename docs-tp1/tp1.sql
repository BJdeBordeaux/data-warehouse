-- Active: 1663745867992@@127.0.0.1@5432@data_warehouse@public
-- ex 2.3.1


SELECT country, count(*) country FROM customers GROUP BY country;

-- ex 2.3.2

SELECT
    ship_country,
    ship_city,
    COUNT(order_id) nb_orders
FROM orders
GROUP BY
    ROLLUP(ship_country, ship_city)
ORDER BY
    ship_country,
    ship_city;

-- ex 2.3.3

SELECT
    O.ship_country C_COUNTRY,
    S.country S_COUNTRY,
    sum(D.quantity),
    count(DISTINCT D.order_id) NBORDER
FROM
    order_details D,
    orders O,
    products P,
    suppliers S
WHERE
    D.order_id = O.order_id
    and D.product_id = P.product_id
    and P.supplier_id = S.supplier_id
GROUP BY
    O.ship_country,
    S.country
ORDER BY
    O.ship_country,
    S.country;

-- ex 2.3.4

SELECT
    O.ship_country C_COUNTRY,
    S.country S_COUNTRY,
    sum(D.quantity) QUANTITY,
    count(DISTINCT D.order_id) NBORDER
FROM
    order_details D,
    orders O,
    products P,
    suppliers S
WHERE
    D.order_id = O.order_id
    and D.product_id = P.product_id
    and P.supplier_id = S.supplier_id
GROUP BY
    CUBE(C_COUNTRY, S_COUNTRY);

-- ORDER BY O.ship_country, S.country

-- ex 2.3.5.1

SELECT
    O.ship_country,
    O.ship_region,
    O.ship_city,
    sum(
        D.quantity * D.unit_price * (1 - D.discount)
    ) as price
FROM
    order_details D,
    orders O,
    products P,
    suppliers S
WHERE
    D.order_id = O.order_id
    and D.product_id = P.product_id
    and P.supplier_id = S.supplier_id
    and s.country = 'France'
GROUP BY
    GROUPING SETS( (
            O.ship_country,
            O.ship_region,
            O.ship_city
        ), (O.ship_country, O.ship_region), (O.ship_country)
    );

-- ex 2.3.5.2

SELECT
    O.ship_country,
    O.ship_region,
    O.ship_city,
    sum(
        D.quantity * D.unit_price * (1 - D.discount)
    ) as price
FROM
    order_details D,
    orders O,
    products P,
    suppliers S
WHERE
    D.order_id = O.order_id
    and D.product_id = P.product_id
    and P.supplier_id = S.supplier_id
    and s.country = 'France' -- modify GROUPING SETS : ROLLUP extended
;

-- ex 2.3.6

SELECT
    ship_country,
    CASE
        WHEN GROUPING(ship_city) = 1 THEN 'whole country'
        ELSE ship_city
    END,
    COUNT(DISTINCT order_id)
FROM orders
GROUP BY
    ROLLUP(ship_country, ship_city)
order by
    ship_country,
    ship_city;

-- ex 2.4.1

SELECT
    ship_country,
    ship_city,
    COUNT(DISTINCT order_id) nborders,
    SUM(COUNT(*)) OVER (PARTITION BY ship_country) as nbordcity,
    MAX(COUNT(DISTINCT order_id)) OVER (PARTITION BY ship_country) as nbormaxcity
FROM orders
GROUP BY
    ship_country,
    ship_city
order by
    ship_country,
    ship_city;

-- ex 2.4.2

SELECT
    ship_country,
    ship_city,
    COUNT(DISTINCT order_id) nborders,
    DENSE_RANK() OVER (
        PARTITION by ship_country
        order by COUNT(*)
    )
FROM orders
GROUP BY
    ship_country,
    ship_city -- order by ship_country, ship_city;
;

-- 2.4.3

SELECT
    ship_country,
    ship_city,
    COUNT(*) nborders,
    ROUND(
        count(*) / SUM(COUNT(*)) OVER (PARTITION by ship_country),
        2
    ) as percentage,
    DENSE_RANK() over (
        PARTITION by ship_country
        order by COUNT(*)
    )
FROM orders
GROUP BY
    ship_country,
    ship_city;

-- 2.4.4

WITH t1 (order_id, price) AS (
        SELECT
            order_id,
            sum(
                unit_price * quantity * (1 - discount)
            ) as price,
            lag(
                sum(
                    unit_price * quantity * (1 - discount)
                ),
                1,
                -1
            ) OVER (
                order by
                    order_id
            ) as previous_price
        FROM order_details
        GROUP BY order_id
    )
SELECT order_id, price:: REAL
FROM t1
WHERE
    price = -1
    OR price <= 1.1 * previous_price;

-- 2.4.5.1

WITH t1 as (
        SELECT EXTRACT(
                YEAR
                FROM
                    O.order_date
            ) year_,
            P.product_name,
            sum(D.quantity) as qtity,
            max(sum(D.quantity)) OVER (
                PARTITION by EXTRACT(
                    YEAR
                    FROM
                        O.order_date
                )
            ) as maxqtt
        FROM
            order_details D,
            products P,
            orders O
        WHERE
            D.product_id = P.product_id
            and O.order_id = D.order_id
        GROUP BY
            year_,
            p.product_name
        ORDER BY
            year_ DESC,
            p.product_name
    )
SELECT
    year_,
    product_name,
    qtity
FROM t1
where qtity = maxqtt;

-- 2.4.5.2

WITH t1 as (
        SELECT EXTRACT(
                YEAR
                FROM
                    O.order_date
            ) year_,
            P.product_name,
            SUM(D.quantity) as qtity
        FROM
            order_details D,
            products P,
            orders O
        WHERE
            D.product_id = P.product_id
            and O.order_id = D.order_id
        GROUP BY
            year_,
            p.product_name
        ORDER BY
            year_ DESC,
            p.product_name
    )
SELECT
    year_,
    product_name,
    qtity
FROM t1
WHERE (year_, qtity) in (
        SELECT
            year_,
            MAX(qtity)
        FROM t1
        GROUP by year_
    );

-- ex 2.5.1

WITH RECURSIVE t (n) AS(
        SELECT 1
        UNION ALL
        SELECT t.n + 1
        FROM t
        WHERE t.n < 60
    )
SELECT n
FROM t;

-- ex 2.8.1

WITH RECURSIVE t (n, un) AS(
        SELECT 0, 127
        UNION ALL
        SELECT
            n + 1,
            case
                when mod(un, 2) = 0 then un / 2
                else 3 * un + 1
            end
        FROM t
        WHERE t.n < 100
    )
SELECT un
FROM t
WHERE n = 50;

-- -- ex 2.6

-- WITH

--     RECURSIVE t (id, pid, le) AS(

--         -- initialisation

--         SELECT

--             id,

--             pid,

--             name,

--             0 level

--         FROM employes

--         WHERE id = 0 -- patron

--         UNION ALL

--         -- récursion

--         SELECT

--             id,

--             pid,

--             name,

--             level + 1

--         FROM employes e, t

--         WHERE

--             e.pid = t.id -- lien récursive

--             AND level < 20 -- limiter la profondeur récursive

--     )

-- SELECT

--     SUBSTR( (LPAD(' '), 2 * level) || name,

--         0,

--         16

--     ),

--     SYS_CONNECT_BY_PATH(name, '/')

-- FROM t;