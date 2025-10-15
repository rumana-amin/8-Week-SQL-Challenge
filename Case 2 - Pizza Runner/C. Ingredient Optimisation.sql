    ----------------- C. Ingredient Optimisation ---------------

--1.What are the standard ingredients for each pizza?
SELECT pr. pizza_id, STRING_AGG(pt.topping_name, ', ' ) AS pizza_ingrdients
FROM pizza_recipes_view AS pr
Left JOIN pizza_toppings_view AS pt
ON pr.topping_id = pt.topping_id
GROUP BY pr.pizza_id;


--2. What was the most commonly added extra?
Select top 2 extra, count(extra) as totals
From customer_orders_view
WHERE extra != ''
Group by extra
Order BY 2 desc;


--3. What was the most common exclusion?
Select exclusion, count(exclusion) as totals
From customer_orders_view
WHERE extra != '' and exclusion!=''
Group by exclusion
Order BY 2 desc;


--4. Generate an order item for each record in the customers_orders table in the format of one of the following:
	  --Meat Lovers
Select order_id
From customer_orders_view
WHERE pizza_id = 1
Group by order_id
Order BY 1;

	  --Meat Lovers - Exclude Beef
Select cr.order_id, cr.pizza_id
From customer_orders_view AS cr
Inner JOIN pizza_recipes_view AS pr
ON cr.pizza_id = pr.pizza_id
Inner JOIN pizza_toppings_view AS pt
ON pr.topping_id = pt.topping_id 
WHERE cr.pizza_id = 1 AND pt.topping_id !=2
Group by order_id, cr.pizza_id
Order BY 1;


	  --Meat Lovers - Extra Bacon
Select cr.order_id, cr.pizza_id, cr.extra
From customer_orders_view AS cr
Inner JOIN pizza_recipes_view AS pr
ON cr.pizza_id = pr.pizza_id
WHERE cr.pizza_id = 1 AND cr.extra = 1
Group by order_id, cr.pizza_id, cr.extra
Order BY 1;

	  --Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

Select cr.order_id, cr.pizza_id, cr.extra, cr.exclusion
From customer_orders_view AS cr
Inner JOIN pizza_recipes_view AS pr
ON cr.pizza_id = pr.pizza_id
WHERE cr.pizza_id = 1 AND cr.extra IN (6,9) AND cr.exclusion NOT IN (4,1)
Group by order_id, cr.pizza_id, cr.extra, cr.exclusion
Order BY 1;


--5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table
--and add a 2x in front of any relevant ingredients
--For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
SELECT 
    co.order_id,
    pn.pizza_name + ': ' +
    STRING_AGG(
        CASE 
            -- double the ingredient if it's in extras
            WHEN CHARINDEX(CAST(pt.topping_id AS varchar), co.extra) > 0 
                THEN '2x' + pt.topping_name
            ELSE pt.topping_name
        END, 
        ', '
    ) WITHIN GROUP (ORDER BY pt.topping_name) AS ingredient_list
FROM customer_orders_view AS co
INNER JOIN pizza_names_view AS pn
    ON co.pizza_id = pn.pizza_id
INNER JOIN pizza_recipes_view AS pr
    ON co.pizza_id = pr.pizza_id
INNER JOIN pizza_toppings_view AS pt
    ON pr.topping_id = pt.topping_id
WHERE 
    -- exclude ingredients listed in exclusions
    (co.exclusion IS NULL 
     OR CHARINDEX(CAST(pt.topping_id AS varchar), co.exclusion) = 0)
GROUP BY co.order_id, pn.pizza_name
ORDER BY co.order_id;


--6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
Select pt.topping_id, pt.topping_name, COUNT(pt.topping_id) as qty_ingredient
From [dbo].[customer_orders_view] AS co
Inner Join runner_orders_view AS ro
    ON co.order_id = ro.order_id
Inner Join pizza_recipes_view AS pr
    ON co.pizza_id = pr.pizza_id
Inner Join pizza_toppings_view as pt
    ON pr.topping_id = pt.topping_id
WHERE ro.pickup_time IS NOT NULL
Group by pt.topping_id, pt.topping_name
Order by qty_ingredient desc;

