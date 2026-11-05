CREATE ACCESS METHOD heap2 TYPE TABLE HANDLER heap_tableam_handler;
CREATE TABLE am_partitioned(x INT, y INT) PARTITION BY hash (x) USING heap2;
DROP ACCESS METHOD heap2;
DROP TABLE am_partitioned;
DROP ACCESS METHOD heap2;
