CREATE TABLE t(a DATE);
COPY t FROM 'data/csv/auto_date/date_example_1.csv' WITH (dateformat 'AUTO');
SELECT * FROM t;
