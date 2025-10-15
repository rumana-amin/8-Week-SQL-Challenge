                                   --B. Runner and Customer Experience

--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
/*
Group the registration_date into custom 7-day periods starting from 2021-01-01
How this works:
DATEDIFF(DAY, '2021-01-01', registration_date) gives how many days since the anchor date.
Dividing by 7 (integer division) buckets into 7-day groups.
Multiplying back by 7 and adding to '2021-01-01' gives the starting date of the week bucket.
*/

SELECT
  DATEADD(DAY, (DATEDIFF(DAY, '2021-01-01', registration_date) / 7) * 7, '2021-01-01') AS week_starting,
  (DATEDIFF(DAY, '2021-01-01', registration_date) / 7) + 1 AS week_number,
  COUNT(*) AS runner_count
FROM runners
GROUP BY 
    DATEADD(DAY, (DATEDIFF(DAY, '2021-01-01', registration_date) / 7) * 7, '2021-01-01'),
    (DATEDIFF(DAY, '2021-01-01', registration_date) / 7) + 1 
ORDER BY week_starting;


--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

WITH cte AS ( 
    SELECT 
        r.runner_id,
        DATEDIFF(MINUTE, c.order_time, r.pickup_time) AS duration
    FROM customer_orders_view AS c
    INNER JOIN runner_orders_view AS r
        ON c.order_id = r.order_id
    WHERE c.order_time IS NOT NULL AND r.pickup_time IS NOT NULL
)
SELECT 
    runner_id, 
    AVG(duration) AS avg_pickup_time
FROM cte
GROUP BY runner_id
ORDER BY runner_id;


--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH cte AS ( 
    SELECT 
	  c.order_id,
        count(c.order_id) AS no_of_pizza,
        DATEDIFF(MINUTE, MIN(c.order_time), MIN(r.pickup_time)) AS duration
    FROM customer_orders_view AS c
    INNER JOIN runner_orders_view AS r
        ON c.order_id = r.order_id
    WHERE c.order_time IS NOT NULL AND r.pickup_time IS NOT NULL
    GROUP BY c.order_id   
)
SELECT 
    no_of_pizza, 
    AVG(duration) AS avg_pickup_time
FROM cte
GROUP BY no_of_pizza;


-- 4.What was the average distance travelled for each customer?
SELECT 
    c.customer_id,
    round(AVG(r.distance),2) AS avg_distance
FROM customer_orders_view AS c
Inner Join runner_orders_view AS r
    ON c.order_id = r.order_id
WHERE r.pickup_time IS NOT NULL
GROUP BY c.customer_id
ORDER BY c.customer_id;


--5.What was the difference between the longest and shortest delivery times for all orders?
SELECT
    MAX(duration) - MIN(duration) AS time_difference 
 FROM runner_orders_view
 WHERE pickup_time IS NOT NULL;


--6.What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT
    r.runner_id,
    ROUND(AVG(r.distance), 2) AS avg_distance,
    ROUND(AVG(r.distance / (r.duration / 60.0)), 2) AS avg_speed
FROM runner_orders_view AS r
INNER JOIN customer_orders_view AS c 
    ON c.order_id = r.order_id
WHERE r.pickup_time IS NOT NULL
GROUP BY r.runner_id
ORDER BY r.runner_id;


--7.What is the successful delivery percentage for each runner?
   WITH CTE AS (
    Select
	  runner_id,
	  COUNT(order_id) as total_order, 
	  COUNT(CASE WHEN cancellation !='' THEN 1 END) as canceled_order,
	  COUNT(order_id) - COUNT(CASE WHEN cancellation !='' THEN 1 END) AS successfull_order
    From runner_orders_view
    GROUP BY runner_id
    ) 
	  SELECT runner_id, CAST(successfull_order AS FLOAT) / total_order * 100.0 AS success_rate
	  FROM CTE;


