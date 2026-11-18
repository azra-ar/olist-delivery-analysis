# Source data

Download and unzip the Brazilian E-Commerce Public Dataset by Olist.

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

| Source CSV | SQLite table | Join key |
| --- | --- | --- |
| `olist_orders_dataset.csv` | `orders` | `order_id`, `customer_id` |
| `olist_order_items_dataset.csv` | `order_items` | `order_id`, `product_id` |
| `olist_products_dataset.csv` | `products` | `product_id` |
| `olist_customers_dataset.csv` | `customers` | `customer_id` |

The Colab notebook requests these files through three upload prompts. Preserve filenames. The first prompt expects only the orders CSV. Source IDs are loaded as text by pandas for this dataset. Each row in order_items represents an order item. The category CTE reduces those rows to one row per eligible order before counting deliveries.

Date fields used are order_purchase_timestamp, order_delivered_carrier_date, order_delivered_customer_date and order_estimated_delivery_date. Customer destination state is customer_state. Category names retain their source Portuguese identifiers.
