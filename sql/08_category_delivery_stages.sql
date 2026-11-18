-- Stage durations for cama_mesa_banho
-- SQL dialect: SQLite

WITH order_categories AS (
    SELECT
        oi.order_id,
        MIN(p.product_category_name) AS category
    FROM order_items AS oi
    LEFT JOIN products AS p
        ON oi.product_id = p.product_id
    GROUP BY oi.order_id
    HAVING COUNT(DISTINCT p.product_category_name) = 1
       AND COUNT(p.product_category_name) = COUNT(*)
),
category_times AS (
    SELECT
        CASE
            WHEN DATE(o.order_delivered_customer_date)
                 > DATE(o.order_estimated_delivery_date)
            THEN 'Late'
            ELSE 'On time'
        END AS delivery_group,

        JULIANDAY(o.order_delivered_carrier_date)
        - JULIANDAY(o.order_purchase_timestamp)
            AS before_carrier_days,

        JULIANDAY(o.order_delivered_customer_date)
        - JULIANDAY(o.order_delivered_carrier_date)
            AS transit_days

    FROM orders AS o
    JOIN order_categories AS c
        ON o.order_id = c.order_id
    WHERE c.category = 'cama_mesa_banho'
      AND o.order_status = 'delivered'
      AND DATE(o.order_delivered_customer_date) IS NOT NULL
      AND DATE(o.order_estimated_delivery_date) IS NOT NULL
)
SELECT
    delivery_group,
    COUNT(*) AS orders_compared,
    ROUND(AVG(before_carrier_days), 2)
        AS avg_before_carrier_days,
    ROUND(AVG(transit_days), 2)
        AS avg_transit_days
FROM category_times
WHERE before_carrier_days >= 0
  AND transit_days >= 0
GROUP BY delivery_group;
