-- Nonnegative stage durations by delivery group
-- SQL dialect: SQLite

WITH delivery_times AS (
    SELECT
        CASE
            WHEN DATE(order_delivered_customer_date)
                 > DATE(order_estimated_delivery_date)
            THEN 'Late'
            ELSE 'On time'
        END AS delivery_group,

        JULIANDAY(order_delivered_carrier_date)
        - JULIANDAY(order_purchase_timestamp)
            AS before_carrier_days,

        JULIANDAY(order_delivered_customer_date)
        - JULIANDAY(order_delivered_carrier_date)
            AS transit_days

    FROM orders
    WHERE order_status = 'delivered'
      AND DATE(order_estimated_delivery_date) IS NOT NULL
)
SELECT
    delivery_group,
    COUNT(*) AS orders_compared,
    ROUND(AVG(before_carrier_days), 2)
        AS avg_before_carrier_days,
    ROUND(AVG(transit_days), 2)
        AS avg_transit_days
FROM delivery_times
WHERE before_carrier_days >= 0
  AND transit_days >= 0
GROUP BY delivery_group;
