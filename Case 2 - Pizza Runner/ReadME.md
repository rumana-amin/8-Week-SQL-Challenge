# Case Study #2 - Pizza Runner

## 📖Introduction
Danny, inspired by a viral Instagram post combining 80s retro style and pizza, launched Pizza Runner—a startup delivering fresh pizzas from his home using a team of “runners” and a mobile app funded on his credit card. With a background in data science, Danny understood the importance of data for scaling his business and has designed a database schema to track operations. Now, he needs help cleaning the data and performing key calculations to optimize delivery and support business growth.

## Entity Relationship Diagram
![](https://github.com/rumana-amin/8-Week-SQL-Challenge/blob/main/Case%202%20-%20Pizza%20Runner/ER%20Diagram.png)

## Case Study Questions
This case study has LOTS of questions - they are broken up by area of focus including:
- A. Pizza Metrics
- B. Runner and Customer Experience
- C. Ingredient Optimisation
- D. Pricing and Ratings
- E. Bonus DML Challenges (DML = Data Manipulation Language)

### 🚀 Each of the following case study questions can be answered using a single SQL statement.


## Data Preparation
There are null values and data types in the customer_orders and runner_orders tables which needed fixing. Here's the lik the data cleaning and preparation link. [Data Peparation](https://github.com/rumana-amin/8-Week-SQL-Challenge/blob/main/Case%202%20-%20Pizza%20Runner/Data%20Cleaning%20and%20Transformation.sql) 

### Code Snippet of data cleaning
```sql
Create View runner_orders_view As
    Select order_id, runner_id, 
	  Case 
		When pickup_time = 'null' OR TRY_CONVERT(datetime, pickup_time) IS NULL Then NULL
		Else Try_convert(datetime,pickup_time)
	  End As pickup_time,
	  Case
		When distance = 'null' Then ''
		Else Try_Convert(Float, Replace(distance,'km',''))
		End AS distance,
	  CASE
		When duration = 'null' Then ''
		ELSE Try_Convert(INT,Left(duration,2))
		End As duration,
	  Case 
		When cancellation Like '%cancel%' Then cancellation
		Else ''
		End AS cancellation
    From runner_orders;
```

## 📂Repository Structure
```
Case 2- Pizza Runner/
│
├── ER Diagram.png/                              # Original ER Diagram of Danny in PNG file
│  
├── SQL Scripts/
|   ├── Schema SQL.sql                           # Original SQL scripts for data loading
│   ├── Data Cleaning and Transformation.sql/    # Scripts for cleaning and transforming data
│   ├── A. Pizza Metrics.sql/                    # Scripts for quering to answer section A questions
│   ├── B. Runner and Consumer Experience.sql/   # Scripts for quering to answer section B questions
|   ├── C. Ingredient Optimization.sql/          # Scripts for quering to answer section C questions
|   ├── D. Pricing and Ratings.sql/              # Scripts for quering to answer section D questions
│   ├── E.Bonus Question.sql/                    # Scripts for quering to answer section B questions
|
├── README.md                                    # Project overview
```

## [A. Pizza Metrics Solution Link](https://github.com/rumana-amin/8-Week-SQL-Challenge/blob/main/Case%202%20-%20Pizza%20Runner/A.%20Pizza%20Metrics.sql)
1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

## [B. Runner and Customer Experience Solution Link](https://github.com/rumana-amin/8-Week-SQL-Challenge/blob/main/Case%202%20-%20Pizza%20Runner/B.%20Runner%20and%20Customer%20Experience.sql)
1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?
## [C. Ingredient Optimisation Solution Link](https://github.com/rumana-amin/8-Week-SQL-Challenge/blob/main/Case%202%20-%20Pizza%20Runner/C.%20Ingredient%20Optimisation.sql)
1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
## D. Pricing and Ratings
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
- Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
## E. Bonus Questions
If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

