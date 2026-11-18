-- Same category cohort ranked by late order count
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
category_results AS (
    SELECT
        c.category,
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
    WHERE o.order_status = 'delivered'
      AND DATE(o.order_delivered_customer_date) IS NOT NULL
      AND DATE(o.order_estimated_delivery_date) IS NOT NULL
    GROUP BY c.category
)
SELECT
    category,
    delivered_orders,
    late_orders,
    ROUND(
        100.0 * late_orders / delivered_orders, 2
    ) AS late_rate_pct
FROM category_results
WHERE delivered_orders >= 100
ORDER BY late_orders DESC, late_rate_pct DESC
LIMIT 10;
