-- Destination states with at least 100 eligible category orders
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
state_results AS (
    SELECT
        cu.customer_state AS state,
        COUNT(*) AS delivered_orders,
        SUM(
            CASE
                WHEN DATE(o.order_delivered_customer_date)
                     > DATE(o.order_estimated_delivery_date)
                THEN 1 ELSE 0
            END
        ) AS late_orders
    FROM orders AS o
    JOIN order_categories AS c
        ON o.order_id = c.order_id
    JOIN customers AS cu
        ON o.customer_id = cu.customer_id
    WHERE c.category = 'cama_mesa_banho'
      AND o.order_status = 'delivered'
      AND DATE(o.order_delivered_customer_date) IS NOT NULL
      AND DATE(o.order_estimated_delivery_date) IS NOT NULL
    GROUP BY cu.customer_state
)
SELECT
    state,
    delivered_orders,
    late_orders,
    ROUND(
        100.0 * late_orders / delivered_orders, 2
    ) AS late_rate_pct
FROM state_results
WHERE delivered_orders >= 100
ORDER BY late_rate_pct DESC;
