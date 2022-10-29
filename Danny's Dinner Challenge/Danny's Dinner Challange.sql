
                                               -- Creating Schemas --  

CREATE DATABASE CHALLENGE;
USE CHALLENGE;
SHOW TABLES;

CREATE TABLE IF NOT EXISTS sales (
  customer_id VARCHAR(10),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales 
	( customer_id , order_date , product_id)
    VALUES 
  ('A', '2021-01-01', 1),
  ('A', '2021-01-01', 2),
  ('A', '2021-01-07', 2),
  ('A', '2021-01-10', 3),
  ('A', '2021-01-11', 3),
  ('A', '2021-01-11', 3),
  ('B', '2021-01-01', 2),
  ('B', '2021-01-02', 2),
  ('B', '2021-01-04', 1),
  ('B', '2021-01-11', 1),
  ('B', '2021-01-16', 3),
  ('B', '2021-02-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-07', 3);
  
  SELECT * FROM sales;
  
  CREATE TABLE IF NOT EXISTS  menu (
  product_id INTEGER,
  product_name VARCHAR(10),
  price INTEGER
);
  
INSERT INTO menu 
  (product_id, product_name, price)
VALUES
  (1, 'sushi', 10),
  (2, 'curry', 15),
  (3, 'ramen', 12);
  
  SELECT * FROM menu;
  
CREATE TABLE IF NOT EXISTS members (
  customer_id VARCHAR(10),
  join_date DATE
);

INSERT INTO members 
	(customer_id , join_date)
VALUES
	('A', '2021-01-07'),
    ('B', '2021-01-09');	
    
    SELECT * FROM members;
    
    
                                               -- Case Study Questions--    
    
-- Each of the following case study questions can be answered using a single SQL statement:

/* 
1.What is the total amount each customer spent at the restaurant?
2.How many days has each customer visited the restaurant?
3.What was the first item from the menu purchased by each customer?
4.What is the most purchased item on the menu and how many times was it purchased by all customers?
5.Which item was the most popular for each customer?
6.Which item was purchased first by the customer after they became a member?
7.Which item was purchased just before the customer became a member?
8.What is the total items and amount spent for each member before they became a member?
9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items,
 not just sushi - how many points do customer A and B have at the end of January?
*/

                                     -- Let's Solve the Questions --
									
SELECT * FROM sales;
SELECT * FROM  members;
SELECT * FROM menu;

-- 1.What is the total amount each customer spent at the restaurant?

SELECT S.customer_id , SUM(M.price) AS Total_Price FROM sales S
	JOIN  menu M
		ON S.product_id = M.product_id
			GROUP BY customer_id;
            
-- 2.How many days has each customer visited the restaurant?

SELECT customer_id , COUNT(DISTINCT(order_date)) as visited_days
	FROM sales
		GROUP BY customer_id;
            
-- 3.What was the first item from the menu purchased by each customer?

SELECT DISTINCT * FROM (
SELECT S.customer_id , S.order_date , M.product_name AS item ,
	DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY order_date ) AS RNK
		FROM sales S
			JOIN menu M
				ON S.product_id = M.product_id) AS A
					WHERE RNK = 1;
                    
-- 4.What is the most purchased item on the menu and how many times was it purchased by all customers?
                
SELECT S.customer_id , M.product_name , COUNT(S.product_id) AS count_items
	FROM sales S
		JOIN menu M
			ON S.product_id = M.product_id
				GROUP BY S.product_id
					ORDER BY count_items DESC 
						LIMIT 1; 
                        
-- 5.Which item was the most popular for each customer? M.product_id

SELECT * FROM  (
SELECT S.customer_id , M.product_name , count(m.product_id) AS item_count,
	DENSE_RANK() OVER(PARTITION BY S.customer_id ORDER BY COUNT(S.customer_id) DESC) AS RNK
		FROM sales S
			JOIN menu M
				ON S.product_id = M.product_id
					GROUP BY customer_id,product_name ) AS A
						WHERE RNK  = 1;
                    

-- 6.Which item was purchased first by the customer after they became a member?

WITH FIRST_PURCHASE_CTE AS (
	SELECT  S.customer_id , S.product_id , S.order_date , MB.join_date,
		DENSE_RANK() OVER(PARTITION BY S.customer_id ORDER BY S.order_date ) AS RNK
			FROM  sales	S
				JOIN members MB
					ON S.customer_id = MB.customer_id
						WHERE S.order_date >= MB.join_date )
    SELECT customer_id, product_name FROM FIRST_PURCHASE_CTE
		JOIN menu M
			ON FIRST_PURCHASE_CTE.product_id = M.product_id
				WHERE RNK = 1
					ORDER BY customer_id;
                    

-- 7.Which item was purchased just before the customer became a member?

WITH FIRST_PURCHASE_CTE AS (
	SELECT  S.customer_id , S.product_id , S.order_date , MB.join_date,
		DENSE_RANK() OVER(PARTITION BY S.customer_id ORDER BY S.order_date DESC ) AS RNK
			FROM  sales	S
				JOIN members MB
					ON S.customer_id = MB.customer_id
						WHERE S.order_date < MB.join_date )
    SELECT DISTINCT customer_id , M.product_name FROM FIRST_PURCHASE_CTE
		JOIN menu M
			ON FIRST_PURCHASE_CTE.product_id = M.product_id
				WHERE RNK = 1
					ORDER BY customer_id;
                    
-- 8.What is the total items and amount spent for each member before they became a member?
   
SELECT S.customer_id , M.product_name , COUNT(distinct (S.product_id)) AS total_items , SUM(M.price) AS total_amount_spent
	FROM sales S
		JOIN menu M
			ON S.product_id = M.product_id
				JOIN members MB
					ON S.customer_id = MB.customer_id
						WHERE S.order_date < MB.join_date
							GROUP BY customer_id;
                
-- 9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH TOTAL AS (
	SELECT S.customer_id , M.product_name , M.price, S.product_id  
			FROM sales S
				JOIN menu M
					ON S.product_id = M.product_id
						)
	SELECT customer_id ,  
		SUM(CASE 
			WHEN product_name = 'sushi' THEN price * 20
            ELSE price * 10
            END) AS points 
				FROM TOTAL
					GROUP BY customer_id;
					
					
		
 /* 
 -- 10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items,
    not just sushi - how many points do customer A and B have at the end of January?
*/

WITH TOTAL AS (
	SELECT S.customer_id ,M.product_name , M.price, S.product_id , S.order_date, MB.join_date , MB.join_date + 6 AS one_week
			FROM sales S
				JOIN menu M
					ON S.product_id = M.product_id
						JOIN members MB
							ON S.customer_id = MB.customer_id
						)
	SELECT customer_id ,  
		SUM(CASE 
			WHEN order_date >= join_date AND order_date <= one_week THEN price* 20
			WHEN product_name = 'sushi' THEN price *20
            ELSE price * 10
            END) AS points 
				FROM TOTAL
					WHERE order_date <= '2021-01-31'
						GROUP BY customer_id
							ORDER BY 1;
	
    
/* 
Insights
1.From the analysis, we discover a few interesting insights that would be certainly useful for Danny.
2.Customer B is the most frequent visitor with 6 visits in Jan 2021.
3.Danny’s Diner’s most popular item is ramen, followed by curry and sushi.
4.Customer A and C loves ramen whereas Customer B seems to enjoy sushi, curry and ramen equally. Who knows, I might be Customer B!
5.Customer A is the 1st member of Danny’s Diner and his first order is curry. Gotta fulfill his curry cravings!
6.The last item ordered by Customers A and B before they became members are sushi and curry.
  Does it mean both of these items are the deciding factor? It must be really delicious for them to sign up as members!
7.Before they became members, both Customers A and B spent $25 and $40.
8.hroughout Jan 2021, their points for Customer A: 860, Customer B: 940 and Customer C: 360.
9.Assuming that members can earn 2x a week from the day they became a member with bonus 2x points for sushi, Customer A has 660 points and Customer B has 340 by the end of Jan 2021.
*/
                                                       -- Thank You --