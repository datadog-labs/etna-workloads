.mode list
.nullvalue NULL
SET threads=1;
SELECT * FROM read_csv(['data/csv/unionbyname_21248_*.csv'], union_by_name = true, ignore_errors = true, all_varchar = true);
