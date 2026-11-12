SELECT CAST(col1 AS BIGINT), CAST(filename AS BIGINT)
FROM read_csv('data/csv/14512.csv', columns={'col1': 'INTEGER'}, ignore_errors=true);
