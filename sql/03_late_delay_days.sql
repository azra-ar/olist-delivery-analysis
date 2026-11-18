-- Calendar-day delays for late delivered orders
-- SQL dialect: SQLite

SELECT
    COUNT(*) AS late_orders,
    ROUND(
        AVG(
            JULIANDAY(DATE(order_delivered_customer_date))
            - JULIANDAY(DATE(order_estimated_delivery_date))
        ), 2
    ) AS average_delay_days,
    CAST(
        MAX(
            JULIANDAY(DATE(order_delivered_customer_date))
            - JULIANDAY(DATE(order_estimated_delivery_date))
        ) AS INTEGER
    ) AS maximum_delay_days
FROM orders
WHERE order_status = 'delivered'
  AND DATE(order_delivered_customer_date)
      > DATE(order_estimated_delivery_date);
