
--Table 2: customer_orders
--The exclusions and extras columns will need to be cleaned up before using them in your queries.

--Table 3: runner_orders
--There are some known data issues with this table so be careful when using this in your queries
-- make sure to check the data types for each column in the schema SQL!


--A. Pizza Metrics
--01. How many pizzas were ordered?

    Select count(pizza_id) as total_pizza
    From customer_orders;

    Select count(pizza_id) as total_pizza
    From customer_orders_view;

--02.How many unique customer orders were made?
     
    Select count(distinct order_id) as total_order
    From customer_orders;

    Select count(distinct order_id) as total_order
    From customer_orders_view;

--03.How many successful orders were delivered by each runner?

    Select runner_id, count(distinct order_id) as delivered_order
    From runner_orders
    Where cancellation not like '%cancel%' OR cancellation IS NULL
    Group By runner_id;

    Select runner_id, count(distinct order_id) as delivered_order
    From runner_orders_view
    Where cancellation not like '%cancel%'
    Group By runner_id;

    --04.How many of each type of pizza was delivered?

    Select c.pizza_id, count(c.pizza_id) as total_pizza
    From runner_orders as r
    Left Join customer_orders as c
    ON r.order_id = c.order_id 
    Where r.cancellation not like '%cancel%' OR r.cancellation IS NULL
    Group BY c.pizza_id;
    
    --04.How many of each type of pizza was delivered?

    Select c.pizza_id, count(c.pizza_id) as total_pizza
    From runner_orders_view as r
    Left Join customer_orders_view as c
    ON r.order_id = c.order_id 
    Where r.cancellation not like '%cancel%'
    Group BY c.pizza_id;

    --05.How many Vegetarian and Meatlovers were ordered by each customer?
    
    Select c.customer_id, n.pizza_name, count(c.pizza_id) as total_pizza
    From customer_orders_view as c
    Left Join pizza_names_view as n
	  ON c.pizza_id = n. pizza_id
    Group By c.customer_id, n.pizza_name
    order BY c.customer_id;


    --06.What was the maximum number of pizzas delivered in a single order?

    Select Top (1) 
	  c.order_id, count(c.pizza_id) as total_pizza
    From customer_orders_view as c
    Left Join runner_orders_view as r
	  ON c.order_id = r.order_id
    Where r.cancellation not like '%cancel%' 
    Group by c.order_id
    Order BY total_pizza desc;


/* 07.For each customer, how many delivered pizzas had at least 1 change 
      and how many had no changes? */

    Select 
	  cv.customer_id,
	  COUNT(
		CASE 
		    WHEN (cv.exclusions != '' OR cv.extras != '') Then 1
		END)
		AS changed,
	  COUNT(
		CASE 
		    WHEN (cv.exclusions = '' AND cv.extras = '') Then 1
		END
	  ) AS unchanged 
    From customer_orders_view as cv
    Left Join runner_orders_view rv
	  ON cv.order_id = rv.order_id
    Where rv.cancellation = ''
    Group BY cv.customer_id
    Order BY cv.customer_id;

--Condition Grouping: (exclusions != '' OR extras != '') AND rv.cancellation = ''

    --08.How many pizzas were delivered that had both exclusions and extras?
    
    Select count(cv.pizza_id) as count_pizza
    From customer_orders_view as cv
    Left Join runner_orders_view rv
    ON cv.order_id = rv.order_id
    Where (exclusions != '' AND extras != '') AND rv.cancellation = ''


    /* 09.What was the total volume of pizzas ordered 
	  for each hour of the day? */
    SELECT 
	  DATEPART(hour, order_time) as hour
	  ,count(pizza_id) as pizza_volume   
    FROM customer_orders_view
    Group by DATEPART(hour, order_time);


    --10.What was the volume of orders for each day of the week?

     SELECT  
	  DATENAME(dw, order_time) as day, 
	  COUNT(pizza_id)as pizza_volume	  
     FROM customer_orders_view
     GROUP BY DATENAME(dw, order_time)
