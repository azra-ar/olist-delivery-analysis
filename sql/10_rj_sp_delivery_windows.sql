-- Actual and estimated calendar-day windows in RJ and SP
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
delivery_windows AS (
    SELECT
        cu.customer_state AS state,

        JULIANDAY(DATE(o.order_delivered_customer_date))
        - JULIANDAY(DATE(o.order_purchase_timestamp))
            AS actual_delivery_days,

        JULIANDAY(DATE(o.order_estimated_delivery_date))
        - JULIANDAY(DATE(o.order_purchase_timestamp))
            AS promised_delivery_days

    FROM orders AS o
    JOIN order_categories AS c
        ON o.order_id = c.order_id
    JOIN customers AS cu
        ON o.customer_id = cu.customer_id
    WHERE c.category = 'cama_mesa_banho'
      AND cu.customer_state IN ('RJ', 'SP')
      AND o.order_status = 'delivered'
)
SELECT
    state,
    COUNT(*) AS orders_compared,
    ROUND(AVG(actual_delivery_days), 2)
        AS avg_actual_delivery_days,
    ROUND(AVG(promised_delivery_days), 2)
        AS avg_promised_delivery_days
FROM delivery_windows
WHERE actual_delivery_days >= 0
  AND promised_delivery_days >= 0
GROUP BY state;
