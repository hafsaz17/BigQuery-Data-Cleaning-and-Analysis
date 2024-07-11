-- Total number of orders placed
SELECT 
    COUNT(order_id) AS total_orders
FROM 
    centering-sweep-399611.pizza_data.orders;

-- Total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_sales
FROM 
    centering-sweep-399611.pizza_data.order_details 
JOIN 
    centering-sweep-399611.pizza_data.pizzas
ON 
    pizzas.pizza_id = order_details.pizza_id;

-- Fetch all order details along with pizza information
SELECT 
    order_details.order_details_id, 
    order_details.order_id, 
    pizzas.pizza_id, 
    pizzas.size, 
    pizzas.price
FROM 
    centering-sweep-399611.pizza_data.order_details
JOIN 
    centering-sweep-399611.pizza_data.pizzas 
ON 
    order_details.pizza_id = pizzas.pizza_id;

-- Calculate the total quantity of each pizza type ordered
SELECT
    pizzas.pizza_type_id,
    pizza_types.name, 
    SUM(order_details.quantity) AS total_quantity
FROM 
    centering-sweep-399611.pizza_data.order_details
JOIN 
    centering-sweep-399611.pizza_data.pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN 
    centering-sweep-399611.pizza_data.pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY 
    pizzas.pizza_type_id, 
    pizza_types.name;

-- Create a CTE to get daily sales summary
WITH daily_sales AS (
  SELECT  
        DATE(orders.date) AS order_date, 
        ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_sales
  FROM 
        centering-sweep-399611.pizza_data.orders
  JOIN 
        centering-sweep-399611.pizza_data.order_details ON orders.order_id = order_details.order_id
  JOIN
        centering-sweep-399611.pizza_data.pizzas ON order_details.pizza_id = pizzas.pizza_id
  GROUP BY 
        order_date
)
SELECT 
    order_date, 
    total_sales
FROM 
    daily_sales
ORDER BY 
    order_date;

-- This is a BigQuery script
BEGIN
-- Create a temporary table to store the average price of each pizza type
CREATE TEMP TABLE avg_pizza_prices AS
SELECT 
    pizzas.pizza_type_id, 
    pizza_types.name, 
    AVG(pizzas.price) AS avg_price
FROM 
    centering-sweep-399611.pizza_data.pizzas
JOIN 
    centering-sweep-399611.pizza_data.pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY 
    pizzas.pizza_type_id, 
    pizza_types.name;
  -- Use the temporary table in another query
  SELECT * FROM avg_pizza_prices;
END; 

-- Create a view to encapsulate a complex query
CREATE VIEW pizza_data.popular_pizzas AS
SELECT 
    pizzas.pizza_id, 
    pizza_types.name, 
    pizzas.size, 
    SUM(order_details.quantity) AS total_quantity
FROM 
    centering-sweep-399611.pizza_data.order_details
JOIN 
    centering-sweep-399611.pizza_data.pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN
    centering-sweep-399611.pizza_data.pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY 
    pizzas.pizza_id, 
    pizza_types.name, 
    pizzas.size
ORDER BY 
    total_quantity DESC;

-- Converting data types for analysis
SELECT 
    CAST(order_id AS STRING) AS order_id_str, 
    CAST(date AS DATE) AS order_date
FROM 
    centering-sweep-399611.pizza_data.orders;