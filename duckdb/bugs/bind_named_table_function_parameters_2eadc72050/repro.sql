SET TimeZone='America/Los_Angeles';
SELECT column_name FROM (DESCRIBE SELECT * FROM read_csv('data/csv/test/date.csv', names => [TIMESTAMPTZ '2024-01-01 12:00:00+00']));
