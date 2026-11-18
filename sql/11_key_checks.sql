-- Row counts and distinct IDs in dimension and order tables
-- SQL dialect: SQLite

SELECT
    'orders' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_ids
FROM orders

UNION ALL

SELECT
    'products',
    COUNT(*),
    COUNT(DISTINCT product_id)
FROM products

UNION ALL

SELECT
    'customers',
    COUNT(*),
    COUNT(DISTINCT customer_id)
FROM customers;
