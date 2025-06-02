--B. Runner and Customer Experience
--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT TOP (1000) [runner_id]
      ,[registration_date]
  FROM [pizza_runner].[dbo].[runners]


SELECT 
    DATEADD(WEEK, DATEDIFF(WEEK, '2021-01-01', registration_date), '2021-01-01') AS week_start,
    COUNT(runner_id) AS total_runners
FROM 
    runners
GROUP BY 
    DATEADD(WEEK, DATEDIFF(WEEK, '2021-01-01', registration_date), '2021-01-01')
ORDER BY 
    week_start;

--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?


Select runner_id, Avg(duration) as avg_time
From runner_orders_view
Where pickup_time IS NOT NULL
Group By runner_id;



--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
Select* From runner_orders_view;
inner Join
Select* From customer_orders_view;


What was the average distance travelled for each customer?
What was the difference between the longest and shortest delivery times for all orders?
What was the average speed for each runner for each delivery and do you notice any trend for these values?
What is the successful delivery percentage for each runner?