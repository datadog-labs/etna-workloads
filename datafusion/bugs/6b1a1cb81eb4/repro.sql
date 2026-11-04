CREATE TABLE median_window_test AS VALUES
 (1,'tag1',10),(2,'tag1',20),(3,'tag1',30),(4,'tag1',40),(5,'tag1',50),
 (1,'tag2',60),(2,'tag2',70),(3,'tag2',80),(4,'tag2',90),(5,'tag2',100);
SELECT column1 AS timestamp, column2 AS tags, column3 AS value,
  median(DISTINCT column3) OVER (PARTITION BY column2 ORDER BY column1
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS distinct_median
FROM median_window_test ORDER BY tags, timestamp;
