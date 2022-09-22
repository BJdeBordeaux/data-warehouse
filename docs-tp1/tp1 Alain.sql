------ LAB 2.2 ------

--- oui la table employees fait référence à elle même

------ LAB 2.3 ------

--- 1

SELECT COUNT(*), country
FROM customers
GROUP BY country;

--- 2 

SELECT ship_country, ship_city, count(*) as nb_orders
FROM orders
GROUP BY ROLLUP(ship_country, ship_city)
ORDER BY ship_country, ship_city;

--- 3

SELECT orders.ship_country AS C_COUNTRY, suppliers.country AS S_COUNTRY, 
	SUM(order_details.quantity) AS QUANTITY, count(distinct orders.order_id) AS NBORDER
FROM ((orders JOIN order_details ON orders.order_id = order_details.order_id) 
    JOIN products ON order_details.product_id = products.product_id)
    JOIN suppliers ON products.supplier_id = suppliers.supplier_id
GROUP BY orders.ship_country, suppliers.country
ORDER BY C_COUNTRY, S_COUNTRY;

--- 4

SELECT orders.ship_country AS C_COUNTRY, suppliers.country AS S_COUNTRY, 
    SUM(order_details.quantity) AS QUANTITY, count(orders.order_id) AS NBORDER
FROM ((orders JOIN order_details ON orders.order_id = order_details.order_id) 
    JOIN products ON order_details.product_id = products.product_id)
    JOIN suppliers ON products.supplier_id = suppliers.supplier_id
GROUP BY CUBE(orders.ship_country, suppliers.country)
ORDER BY C_COUNTRY, S_COUNTRY;

--- 5
SELECT orders.ship_country as SHIP_COUNTRY, orders.ship_region AS SHIP_REGION,
    orders.ship_city AS SHIP_CITY,
    SUM(order_details.quantity * order_details.unit_price * (1 - order_details.discount)) AS PRICE
FROM ((orders JOIN order_details ON orders.order_id = order_details.order_id)
    JOIN products ON order_details.product_id = products.product_id)
    JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE suppliers.country = 'France'
GROUP BY GROUPING SETS ((orders.ship_country,orders.ship_region, orders.ship_city),
    (orders.ship_country,orders.ship_region), (orders.ship_city))
ORDER BY SHIP_COUNTRY,SHIP_REGION,SHIP_CITY;

--- 5 bis

SELECT orders.ship_country as SHIP_COUNTRY, orders.ship_region AS SHIP_REGION,
    orders.ship_city AS SHIP_CITY,
    SUM(order_details.quantity * order_details.unit_price * (1 - order_details.discount)) AS PRICE
FROM ((orders JOIN order_details ON orders.order_id = order_details.order_id)
    JOIN products ON order_details.product_id = products.product_id)
    JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE suppliers.country = 'France'
GROUP BY orders.ship_country, ROLLUP (orders.ship_region, orders.ship_city)
ORDER BY SHIP_COUNTRY,SHIP_REGION,SHIP_CITY;

--- 6

--- pas possible avec sqlliteOnline

------ LAB 2.4 ------

--- 1 

SELECT ship_country, ship_city, count(*) as nborders,
    sum(count(*)) OVER(PARTITION BY ship_country) as NBORDCTY,
    max(count(*)) OVER(PARTITION BY ship_country) as NBORMAXCTY
FROM orders
GROUP BY ship_country, ship_city;


--- 2 

SELECT ship_country, ship_city, count(*) as nborders,
    sum(count(*)) OVER(PARTITION BY ship_country) as NBORDCTY,
    max(count(*)) OVER(PARTITION BY ship_country) as NBORMAXCTY,
    RANK() OVER(PARTITION BY ship_country ORDER BY count(*) ASC) RK
FROM orders
GROUP BY ship_country, ship_city;

--- 3

SELECT ship_country, ship_city, count(*) as nborders,
    sum(count(*)) OVER(PARTITION BY ship_country) as NBORDCTY,
    max(count(*)) OVER(PARTITION BY ship_country) as NBORMAXCTY,
    RANK() OVER(PARTITION BY ship_country ORDER BY count(*) ASC) RK,
    round(count(*) / sum(count(*)) OVER(PARTITION BY ship_country),2) as percentG
FROM orders
GROUP BY ship_country, ship_city;

--- 4

WITH tpm AS (
    SELECT order_details.order_id AS ORDER_ID,
    SUM(order_details.quantity * order_details.unit_price * (1 - order_details.discount)) AS PRICE,
    LAG(SUM(order_details.quantity * order_details.unit_price * (1 - order_details.discount)), 1, -1) 
    OVER(ORDER BY ORDER_ID) AS previous
    FROM order_details
    GROUP by order_details.order_id
)

SELECT ORDER_ID, PRICE
FROM tpm
WHERE previous = -1 OR price <= 1.1 * previous
ORDER BY ORDER_ID;
