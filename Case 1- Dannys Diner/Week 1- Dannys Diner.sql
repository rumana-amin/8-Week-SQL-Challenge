/* --------------------
   Case Study Questions
   --------------------*/
Use dannys_diner


-- 1. What is the total amount each customer spent at the restaurant?

	  Select s.customer_id, sum(price) as total_amount
	  From sales as s
	  Inner Join menu as m 
		ON m.product_id = s.product_id
	  Group by s.customer_id;


-- 2. How many days has each customer visited the restaurant?
	  
	  Select customer_id, COUNT(distinct order_date) as no_of_days
	  From sales
	  Group by customer_id;


-- 3. What was the first item from the menu purchased by each customer?

	  --Method 1: CTE
	  With cte as
	  (
	  Select s.customer_id, m.product_name, s.order_date,
		    rank() over( partition by s.customer_id order by s.order_date asc) as first_order
	  From sales as s
	  Inner Join menu as m
		ON m.product_id = s.product_id
		Group by s.customer_id, m.product_name, s.order_date
		)
	  Select customer_id, product_name
	  From cte
	  Where first_order = 1;


	  -- Method 2: Subquery
	  SELECT s.customer_id, m.product_name, s.order_date
	  FROM sales AS s
	  INNER JOIN menu AS m
		ON m.product_id = s.product_id
	  WHERE s.order_date = (
		SELECT MIN(order_date)
		FROM sales
		WHERE customer_id = s.customer_id
	  )
	  Group by s.customer_id, m.product_name, s.order_date;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
	  
	  
	  With cte as (
		    Select m.product_name, count (s.order_date) as total_purchase
				, RANK() over(order by count (s.order_date) desc) as rnk
		    From sales as s
		    Inner Join menu as m
			  ON m.product_id = s.product_id
		    Group by m.product_name 
		    )

	  Select product_name, total_purchase
	  From cte
	  Where rnk = 1;


-- 5. Which item was the most popular for each customer?

    With cte As(
		Select s.customer_id, m.product_name, COUNT(s.order_date) as total_purchase 
		    , RANK() over( partition by s.customer_id order by COUNT(s.order_date) desc) as rnk
		From sales as s
		Inner Join menu as m
		    ON m.product_id = s.product_id
		Group by s.customer_id, m.product_name
		)
    Select customer_id, product_name, total_purchase 
    From cte
    Where rnk = 1;

-- 6. Which item was purchased first by the customer after they became a member?

--Method 1: CTE
  With cte as (
		Select s.customer_id, s.product_id, MIN(s.order_date) as min_order_date, m.join_date
		    , RANK() over(partition by s.customer_id order by MIN(s.order_date) asc)as rnk
		    , menu.product_name 
		From sales as s 
		Inner Join members as m
		    ON s.customer_id = m.customer_id
		Inner Join menu as menu ON s.product_id = menu.product_id
		Where s.order_date > m.join_date
		Group by s.customer_id, s.product_id, m.join_date, menu.product_name 
		)

    Select t.customer_id, m.product_name
    From cte as t
    Inner Join menu as m
	  ON t.product_id = m.product_id
    Where t.rnk = 1;


--Method 2: Subquery
Select t.customer_id, t.product_name
From (
	  Select s.order_date, s.customer_id, s.product_id, m.join_date, mn.product_name
		, RANK() over(partition by s.customer_id order by s.order_date asc) as rnk
	  From sales as s
	  Inner Join members as m
	  on s.customer_id = m.customer_id
	  Inner Join menu as mn
		ON mn.product_id = s.product_id
	  Where m.join_date < s.order_date) t
Where t.rnk = 1 



-- 7. Which item was purchased just before the customer became a member?

	  With cte as (
		    Select s.customer_id, s.order_date, s.product_id, m.join_date, mn.product_name
		    , RANK() over (PARTITION BY s.customer_id order by s.order_date desc) AS rnk
		    From sales as s
		    Inner Join members as m
			  ON s.customer_id = m.customer_id
		    Inner Join menu as mn
			  ON s.product_id = mn.product_id
		    Where s.order_date < m.join_date
		    Group BY s.customer_id, s.product_id, m.join_date, mn.product_name, s.order_date
		    )

	  Select  customer_id, product_name, order_date, join_date
	  From cte
	  Where rnk = 1;


-- 8. What is the total items and amount spent for each member before they became a member?

	  With cte as (
		    Select s.customer_id, s.order_date, s.product_id, m.join_date, mn.product_name
			  , COUNT(s.product_id) over(partition by s.customer_id) as total_items
			  , sum(mn.price) over (PARTITION BY s.customer_id) as amount_spent
		    From sales as s
		    Inner Join members as m
			  ON s.customer_id = m.customer_id
		    Inner Join menu as mn
			  ON s.product_id = mn.product_id
		    Where s.order_date < m.join_date
		    )

	  Select distinct customer_id, total_items, amount_spent
	  From cte;


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier
	  -- how many points would each customer have?

    With cte as (
		 Select s.customer_id, m.price, m.product_name
		    , case 
				when  m.product_name = 'sushi' then  m.price * 10 * 2 
				else m.price * 10
		    end as points
		From sales as s
		Left Join menu as m
		    ON s.product_id = m.product_id
		    )
    Select customer_id, SUM(points) as points
    From cte
    Group by customer_id;


-- 10. In the first week after a customer joins the program (including their join date) 
	  --they earn 2x points on all items, not just sushi
      -- how many points do customer A and B have at the end of January?
	-- need to check

    With cte as (
		Select s.customer_id, s.order_date, mn.join_date, m.price, m.price * 2 as points
		From sales as s
		Inner Join members as mn
		    ON s.customer_id = mn.customer_id
		Inner Join menu as m 
		    ON m.product_id = s.product_id
		Where DATEPART(week, s.order_date) != 1 

		Union

		Select s.customer_id, s.order_date, mn.join_date, m.price, m.price as points
		From sales as s
		Inner Join members as mn
		    ON s.customer_id = mn.customer_id
		Inner Join menu as m 
		    ON m.product_id = s.product_id
		Where DATEPART(week, s.order_date) = 1
		)

    Select customer_id, SUM(points) as points
    From cte
    Where order_date >= '20210101' AND order_date <= '20210131'
    Group by customer_id;
 

--BONUS 1:
-- Recreate the table with — customer_id, order_date, product_name, price, 
--member (Y/N) so that Danny would not need to join the underlying tables using SQL.

    Create View order_member_status
    AS
    Select s.customer_id, s.order_date, mn.product_name, mn.price
	,CASE 
	  When m.join_date <= s.order_date Then 'Y'
	  ELSE 'N'
	END AS member
    From sales as s
    Left Join members as m ON s.customer_id = m.customer_id 
    Join  menu as mn ON  s.product_id = mn.product_id;

/*
--BONUS 2:
--Rank All The Things
-- Danny also requires further information about the ranking of customer products,
but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program. */

    With customers_data AS(
		Select s.customer_id, s.order_date, mn.product_name, mn.price
		    ,CASE When m.join_date <= s.order_date Then 'Y'
			  ELSE 'N'
			  END AS member
		From sales as s 
		Left Join menu as mn
		    ON s.product_id = mn.product_id
		Join members as m ON s.customer_id = m.customer_id
		)
    Select *
    , CASE WHEN member = 'N' THEN NUll
	  ELSE RANK() OVER(PARTITION BY customer_id, member Order By order_date asc) END AS ranking
    From customers_data;



