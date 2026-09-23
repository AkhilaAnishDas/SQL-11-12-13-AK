-- =========================================================
-- ASSIGNMENTS 11, 12 & 13
-- JSON & ADVANCED TYPES
-- Database: order_db
-- Name: Akhila Anish Das
-- Roll No: 150096725016
-- =========================================================


-- =========================================================
-- ASSIGNMENT 11
-- HANDLING JSON IN SQL
-- =========================================================


-- Q1. List the order_id and payment_method for every order.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    order_id,
    order_meta->>'payment_method' AS payment_method
FROM orders;


-- =========================================================
-- Q2. List the order_id and shipping city for every order.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    order_id,
    order_meta->'shipping'->>'city' AS shipping_city
FROM orders;


-- =========================================================
-- Q3. List the order_id and payment_method for orders
-- whose status is pending or shipped.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    order_id,
    order_meta->>'payment_method' AS payment_method
FROM orders
WHERE order_meta->>'status' IN ('pending', 'shipped');


-- =========================================================
-- Q4. Count the number of orders for each payment_method.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    order_meta->>'payment_method' AS payment_method,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_meta->>'payment_method';


-- =========================================================
-- Q5. Update order_id = 3 so its status becomes delivered
-- without altering any other key.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

UPDATE orders
SET order_meta = jsonb_set(
    order_meta,
    '{status}',
    '"delivered"'
)
WHERE order_id = 3;


-- =========================================================
-- ASSIGNMENT 12
-- ARRAY DATA TYPES
-- =========================================================


-- Q1. List product_name and tags for every product
-- tagged 'new'.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    product_name,
    tags
FROM products
WHERE 'new' = ANY(tags);


-- =========================================================
-- Q2. List product_name for every product tagged with
-- both 'furniture' and 'office'.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    product_name
FROM products
WHERE tags @> ARRAY['furniture', 'office'];


-- =========================================================
-- Q3. For each product, show product_name and number
-- of tags assigned to it.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    product_name,
    array_length(tags, 1) AS tag_count
FROM products;


-- =========================================================
-- Q4. List product_name and June sales figure,
-- ordered from highest to lowest.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    product_name,
    monthly_sales[6] AS june_sales
FROM products
ORDER BY monthly_sales[6] DESC;


-- =========================================================
-- Q5. Add 'clearance' to the Desk product's existing tags.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

UPDATE products
SET tags = array_append(tags, 'clearance')
WHERE product_id = 105;


-- =========================================================
-- ASSIGNMENT 13
-- DATE AND TIME FUNCTIONS
-- =========================================================


-- Q1. List order_id, order_date and month name.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    order_id,
    order_date,
    TO_CHAR(order_date, 'Month') AS month_name
FROM orders;


-- =========================================================
-- Q2. Find the number of orders placed in each calendar year.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    COUNT(*) AS order_count
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY order_year;


-- =========================================================
-- Q3. List orders placed in the last 30 days from
-- the most recent order_date in the table.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    order_id,
    order_date
FROM orders
WHERE order_date >= (
    SELECT MAX(order_date)
    FROM orders
) - INTERVAL '30 days'
AND order_date <= (
    SELECT MAX(order_date)
    FROM orders
)
ORDER BY order_date;


-- =========================================================
-- Q4. For each customer, show customer_name and the
-- number of days since their most recent order.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    c.customer_name,
    CURRENT_DATE - MAX(o.order_date) AS days_since_last_order
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;


-- =========================================================
-- Q5. List order_id, order_date and day-of-week name.

-- Name: Akhila Anish Das
-- Roll No: 150096725016

SELECT
    order_id,
    order_date,
    TO_CHAR(order_date, 'Day') AS day_of_week
FROM orders;