/*

More advanced SQL

------------------------------------------------------------------------------------------------

HOW TO GET THE SCHEMA OF A DATABASE: 
* Windows/Linux: Ctrl + r
* MacOS: Cmd + r

*/

/**************************
***************************
CHALLENGES
***************************
**************************/

-- In SQL we can have many databases, they will show up in the schemas list
-- We must first define which database we will be working with
USE publications; 
 
/**************************
ALIAS
**************************/
-- https://www.w3schools.com/sql/sql_alias.asp

-- 1. From the sales table, change the column name qty to Quantity


-- 2. Assign a new name into the table sales. Select the column order number using the table alias


/**************************
JOINS
**************************/
-- https://www.w3schools.com/sql/sql_join.asp

/* We will only use LEFT, RIGHT, and INNER joins this week
You do not need to worry about the other types for now */

-- LEFT JOIN example
-- https://www.w3schools.com/sql/sql_join_left.asp
SELECT *
FROM stores s
LEFT JOIN discounts d 
ON d.stor_id = s.stor_id;

-- RIGHT JOIN example
-- https://www.w3schools.com/sql/sql_join_right.asp
SELECT *
FROM stores s
RIGHT JOIN discounts d
ON d.stor_id = s.stor_id;

-- INNER JOIN example
-- https://www.w3schools.com/sql/sql_join_inner.asp
SELECT *
FROM stores s
INNER JOIN discounts d 
ON d.stor_id = s.stor_id;

-- 3. Using LEFT JOIN: in which cities has "Is Anger the Enemy?" been sold?
-- HINT: you can add WHERE function after the joins

USE publications;

SELECT s.title_id, t.title, st.city
FROM sales s
LEFT JOIN titles t ON s.title_id = t.title_id
LEFT JOIN stores st
        ON s.stor_id = st.stor_id
WHERE t.title = "Is Anger the Enemy?";


-- 4. Using RIGHT JOIN: select all the books (and show their titles) that have a link to the employee Howard Snyder.


-- 5. Using INNER JOIN: select all the authors that have a link (directly or indirectly) with the employee Howard Snyder


-- 6. Using the JOIN of your choice: Select the book title with higher number of sales (qty)

SELECT t.title, SUM(s.qty)
FROM titles t
JOIN sales s ON t.title_id = s.title_id
GROUP BY t.title
ORDER BY SUM(qty) DESC
LIMIT 1;



/**************************
CASE
**************************/
-- https://www.w3schools.com/sql/sql_case.asp

-- 7. Select everything from the sales table and create a new column called "sales_category" with case conditions to categorise qty
--  * qty >= 50 high sales
--  * 20 <= qty < 50 medium sales
--  * qty < 20 low sales
SELECT *, 
CASE WHEN qty >= 50 THEN "high sale"
WHEN qty BETWEEN 20 AND 50 THEN "medium sale"
ELSE "low sale"
END AS "sales_category"
FROM sales;


-- 8. Adding to your answer from question 28. Find out the total amount of books sold (qty) in each sales category
-- i.e. How many books had high sales, how many had medium sales, and how many had low sales

SELECT SUM(qty), 
CASE WHEN qty >= 50 THEN "high sale"
WHEN qty BETWEEN 20 AND 50 THEN "medium sale"
ELSE "low sale"
END AS "sales_category"
FROM sales
GROUP BY sales_category
HAVING SUM(qty) > 100
ORDER BY SUM(qty) DESC;


-- 9. Adding to your answer from question 29. Output only those sales categories that have a SUM(qty) greater than 100, and order them in descending order


-- 10. Find out the average book price, per publisher, for the following book types and price categories:
-- book types: business, traditional cook and psychology
-- price categories: <= 5 super low, <= 10 low, <= 15 medium, > 15 high

-- How many products of these tech categories have been sold (within the time window of the database snapshot)?
-- How many products of these tech categories have been sold (within the time window of the database snapshot)
--  SOLVED BY RAMI
USE magist;	

SELECT COUNT(DISTINCT(oi.product_id)) AS tech_products_sold
	 FROM order_items oi
	 LEFT JOIN products p 
USING (product_id)
	 LEFT JOIN product_category_name_translation pt 
     USING (product_category_name)
		 WHERE product_category_name_english IN("audio", "electronics", "computers_accessories","pc_gamer", "computers","tablets_printing_image","telephony");

-- ans 3390

-- What’s the average price of the products being sold?  TECH PRODUCT
-- MY query
SELECT AVG(oi.price)
	 FROM order_items oi
	 LEFT JOIN products p 
USING (product_id)
	 LEFT JOIN product_category_name_translation pt 
     USING (product_category_name)
		 WHERE product_category_name_english IN("audio", "electronics", "computers_accessories","pc_gamer", "computers","tablets_printing_image","telephony");
-- ans 106.253
USE magist;

SELECT s.seller_id, pt.product_category_name_english
FROM  sellers s
LEFT JOIN order_items oi ON s.seller_id = oi.seller_id
LEFT JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", 
"telephony");

-- how many sellers are there?

SELECT COUNT(DISTINCT seller_id)
FROM sellers;
-- ANS  3095

-- SELLERS Q 2  How many Tech sellers are there
USE publications;

SELECT COUNT(DISTINCT s.seller_id) AS Tech_sellers
FROM  sellers s
LEFT JOIN order_items oi ON s.seller_id = oi.seller_id
LEFT JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", 
"telephony");
-- ANS 454

-- What is the total amount earned by all sellers?



-- What is the total amount earned by all Tech sellers?
USE magist;

SELECT SUM(payment_value)
FROM order_payments op 
LEFT JOIN order_items oi ON op.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", 
"telephony");

-- 2683733.1261218693

-- What’s the average time between the order being placed and the product being delivered?

USE magist;

SELECT  AVG(DATEDIFF(order_purchase_timestamp, order_delivered_customer_date))
FROM orders;

-- What’s the average time between the order being placed and the product being delivered? TECH PRODUCTS

USE magist;

SELECT  AVG(DATEDIFF(order_purchase_timestamp, order_delivered_customer_date))
FROM orders O
LEFT JOIN order_items oi USING (order_id)
LEFT JOIN products p USING (product_id)
LEFT JOIN product_category_name_translation USING (product_category_name)
WHERE  product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", 
"telephony");

-- Is there any pattern for delayed orders, e.g. big products being delayed more often?  to check 


USE magist;
SELECT o.order_id, pt.product_category_name_english, order_estimated_delivery_date, order_delivered_customer_date, DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date),

CASE
WHEN DATEDIFF(order_estimated_delivery_date,order_delivered_customer_date)
 < 1 THEN "delayed"
WHEN DATEDIFF(order_estimated_delivery_date,order_delivered_customer_date) BETWEEN 8 AND 20 THEN "fast_delivery"
ELSE "Super_fast"
END AS time_difference
FROM orders O
LEFT JOIN order_items oi USING (order_id)
LEFT JOIN products p USING (product_id)
LEFT JOIN product_category_name_translation pt USING (product_category_name)
WHERE  pt.product_category_name_english IN ("audio", "electronics", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", 
"telephony");


-- QUERY NOT IN QUESTIONS
SELECT AVG(oi.price), product_category_name_english
	 FROM order_items oi
	 LEFT JOIN products p 
USING (product_id)
	 LEFT JOIN product_category_name_translation pt 
     USING (product_category_name)
		 WHERE product_category_name_english IN("audio", "electronics", "computers_accessories","pc_gamer", "computers","tablets_printing_image","telephony")
GROUP BY product_category_name_english