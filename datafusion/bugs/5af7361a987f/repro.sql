SET datafusion.execution.target_partitions = 4;
CREATE TABLE issue_20194_t1 (value_1_1 decimal(25) NULL, value_1_2 int NULL, value_1_3 bigint NULL);
CREATE TABLE issue_20194_t2 (value_2_1 bigint NULL, value_2_2 varchar(140) NULL, value_2_3 varchar(140) NULL);
INSERT INTO issue_20194_t1 VALUES (6774502793, 10040029, 1120);
INSERT INTO issue_20194_t2 VALUES (1120, '0', '0');
SELECT
  t1.value_1_1, t1.value_1_2,
  ROW_NUMBER() OVER (
    PARTITION BY t1.value_1_1, t1.value_1_2
    ORDER BY
      CASE WHEN t2.value_2_2 = '0' THEN 1 ELSE 0 END ASC,
      CASE WHEN t2.value_2_3 = '0' THEN 1 ELSE 0 END ASC
  ) AS ord
FROM issue_20194_t1 t1
INNER JOIN issue_20194_t2 t2
  ON t1.value_1_3 = t2.value_2_1
  AND nvl(t2.value_2_3, '0') = '0';
