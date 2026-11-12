.mode list
.nullvalue NULL
SET threads=1;
SELECT col1 FROM read_csv('data/csv/26049.csv', columns={'col1': 'VARCHAR', 'col2': 'VARCHAR'}, escape='\', header=true, auto_detect=false, strict_mode=false);
SELECT col1 FROM read_csv('data/csv/26049.csv', columns={'col1': 'VARCHAR', 'col2': 'VARCHAR'}, escape='\', header=true, auto_detect=false, strict_mode=true);
