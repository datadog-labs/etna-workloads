SELECT sum(strlen(state)) FROM (
 SELECT state FROM 'data/parquet-testing/issue6630_2.parquet'
 WHERE suspended AND actual_time >= '2000-01-01');
