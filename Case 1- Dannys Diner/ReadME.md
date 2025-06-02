# Case Study #1 - Danny's Diner
## Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

### 3 key datasets for this case study:
1. sales
2. menu
3. members
## Entity Relationship Diagram

![](https://github.com/rumana-amin/8-Week-SQL-Challenge/blob/main/Case%201-%20Dannys%20Diner/ER%20Diagram.png)

## Case Study Questions
Each of the following case study questions need to be answered using a single SQL statement:
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

## Solution
Click the link below for the answer of all the sql queries.
[Case 1- Dannys Diner/Week 1- Dannys Diner.sql](https://github.com/rumana-amin/8-Week-SQL-Challenge/blob/main/Case%201-%20Dannys%20Diner/Week%201-%20Dannys%20Diner.sql)

Here is the query to answer question no 10.

'''

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
'''
