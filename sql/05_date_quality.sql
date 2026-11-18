-- Missing timestamps and inconsistent event sequences
-- SQL dialect: SQLite

WITH durations AS (
    SELECT
        JULIANDAY(order_delivered_carrier_date)
        - JULIANDAY(order_purchase_timestamp) AS before_carrier,

        JULIANDAY(order_delivered_customer_date)
        - JULIANDAY(order_delivered_carrier_date) AS transit

    FROM orders
    WHERE order_status = 'delivered'
      AND DATE(order_delivered_customer_date) IS NOT NULL
      AND DATE(order_estimated_delivery_date) IS NOT NULL
)
SELECT
    COUNT(*) AS total_orders,

    SUM(CASE
        WHEN before_carrier IS NULL OR transit IS NULL
        THEN 1 ELSE 0
    END) AS missing_or_unreadable_dates,

    SUM(CASE
        WHEN before_carrier IS NOT NULL
         AND transit IS NOT NULL
         AND (before_carrier < 0 OR transit < 0)
        THEN 1 ELSE 0
    END) AS inconsistent_date_order
FROM durations;
