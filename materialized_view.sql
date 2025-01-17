--- Command to creat the materialized view -- 
CREATE MATERIALIZED VIEW monthly_sales_report AS
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS sales_month,
    p.category,
    SUM(o.total_amount) AS total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY TO_CHAR(order_date, 'YYYY-MM'), p.category
ORDER BY sales_month, category;

--- Making query to the Materialized view --
SELECT * FROM monthly_sales_report;


--- Command to refresh the materialized view --
REFRESH MATERIALIZED VIEW monthly_sales_report; 

--- Command to Concurrently refresh  the materialized view --
REFRESH MATERIALIZED VIEW CONCURRENTLY monthly_sales_report;

--- Command to create the pg_cron job to refresh the materialized view --
CREATE EXTENSION IF NOT EXISTS pg_cron;

---This is the example of refreshing the materialized view every minute.
SELECT cron.schedule('* * * * *', $$REFRESH MATERIALIZED VIEW monthly_sales_report$$); 
--- Command to list the pg_cron jobs --
SELECT * FROM cron.job;

--- Command to update the cron job to refresh the materialized view every 5 minutes --
SELECT cron.unschedule('* * * * *', $$REFRESH MATERIALIZED VIEW monthly_sales_report$$);
SELECT cron.schedule('*/5 * * * *', $$REFRESH MATERIALIZED VIEW monthly_sales_report$$);

--- Command to drop the pg_cron job to refresh the materialized view --
SELECT cron.unschedule('* * * * *', $$REFRESH MATERIALIZED VIEW monthly_sales_report$$);

--- Command to drop the materialized view --
DROP MATERIALIZED VIEW monthly_sales_report;