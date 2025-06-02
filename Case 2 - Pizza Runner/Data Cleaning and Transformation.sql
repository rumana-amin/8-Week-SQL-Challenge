-- Data Cleaning and Transformation

-- Table: pizza_names
-- pizza_name_view
    GO
	  Create View pizza_names_view AS
		Select pizza_id, CAST(pizza_name as varchar(10)) as pizza_name
		From pizza_names;

-- Table: pizza_recipes
-- pizza_recipies_view
    GO
    Create View pizza_recipes_view AS
	  Select pizza_id, CAST(toppings as varchar(10)) as toppings
	  From pizza_recipes;

-- Table: pizza_toppings
--pizza_toppings_view
    GO   
    Create View pizza_toppings_view AS
	   Select topping_id, CAST(topping_name as varchar(15)) as topping_name
	   From pizza_toppings;

-- Table: customer_orders 
    
    GO
    Create View customer_orders_view As
    Select order_id, customer_id, pizza_id, order_time, 
	Case 
	    When exclusions = 'null' OR exclusions is NULL then '' 
	    Else exclusions 
	End as exclusions,
	Case
	    When extras = 'null' OR extras IS NULL then '' 
	    Else extras 
	End as extras
    From customer_orders;

--Table: runner_orders
--Ensure Data Compatibility: If this query returns any rows, need to clean or transform those entries before proceeding.
SELECT 
    pickup_time
FROM 
    runner_orders
WHERE 
    TRY_CONVERT(DATETIME, pickup_time) IS NULL AND pickup_time IS NOT NULL;

-- And it returns value = null

    GO
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


GO
SELECT* FROM runner_orders;