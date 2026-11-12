SET allowed_directories=['data/csv/','data/csv/a/','data/csv/b/'];
SET enable_external_access=false;
SELECT count(*) FROM 'data/csv/glob/f_1.csv';
