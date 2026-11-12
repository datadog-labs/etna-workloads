SET allowed_directories=['~'];
SET enable_external_access=false;
SET home_directory='data/csv';
SELECT * FROM read_csv('~/test.csv') LIMIT 1;
