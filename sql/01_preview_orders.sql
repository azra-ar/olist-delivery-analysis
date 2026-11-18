-- First five source orders
-- SQL dialect: SQLite

SELECT
    order_status,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders
LIMIT 5;
