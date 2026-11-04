SET datafusion.execution.target_partitions = 4;
SET datafusion.optimizer.repartition_aggregations = true;
COPY (SELECT column1 as channel, column2 as brand, column3 as amount FROM (VALUES
    ('store', 'nike', 100),
    ('store', 'nike', 200),
    ('store', 'adidas', 150)
)) TO 'sales/part=1/data.parquet' STORED AS PARQUET;
COPY (SELECT column1 as channel, column2 as brand, column3 as amount FROM (VALUES
    ('store', 'adidas', 250),
    ('web', 'nike', 300),
    ('web', 'nike', 400)
)) TO 'sales/part=2/data.parquet' STORED AS PARQUET;
COPY (SELECT column1 as channel, column2 as brand, column3 as amount FROM (VALUES
    ('web', 'adidas', 350),
    ('web', 'adidas', 450),
    ('catalog', 'nike', 500)
)) TO 'sales/part=3/data.parquet' STORED AS PARQUET;
COPY (SELECT column1 as channel, column2 as brand, column3 as amount FROM (VALUES
    ('catalog', 'nike', 600),
    ('catalog', 'adidas', 550),
    ('catalog', 'adidas', 650)
)) TO 'sales/part=4/data.parquet' STORED AS PARQUET;
CREATE EXTERNAL TABLE sales (channel VARCHAR, brand VARCHAR, amount INT) STORED AS PARQUET PARTITIONED BY (part INT) LOCATION 'sales/';
SELECT channel, brand, SUM(total) as grand_total
FROM (
    SELECT 'store' as channel, brand, SUM(amount) as total FROM sales WHERE channel = 'store' GROUP BY brand
    UNION ALL
    SELECT 'web' as channel, brand, SUM(amount) as total FROM sales WHERE channel = 'web' GROUP BY brand
    UNION ALL
    SELECT 'catalog' as channel, brand, SUM(amount) as total FROM sales WHERE channel = 'catalog' GROUP BY brand
) sub
GROUP BY ROLLUP(channel, brand)
ORDER BY channel NULLS FIRST, brand NULLS FIRST;
