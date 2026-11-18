-- Delivered orders with both delivery dates
-- SQL dialect: SQLite

SELECT
    COUNT(*) AS delivered_orders,
    SUM(
        CASE WHEN DATE(order_delivered_customer_date)
                > DATE(order_estimated_delivery_date)
             THEN 1 ELSE 0 END
    ) AS late_orders,
    ROUND(
        100.0 * AVG(
            CASE WHEN DATE(order_delivered_customer_date)
                    > DATE(order_estimated_delivery_date)
                 THEN 1 ELSE 0 END
        ), 2
    ) AS late_rate_pct
FROM orders
WHERE order_status = 'delivered'
  AND DATE(order_delivered_customer_date) IS NOT NULL
  AND DATE(order_estimated_delivery_date) IS NOT NULL;
