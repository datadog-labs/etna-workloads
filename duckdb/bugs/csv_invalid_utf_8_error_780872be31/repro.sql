.mode list
.nullvalue NULL
SELECT count(b) FROM read_csv('data/csv/invalid_utf8_projected.csv', sample_size=1);
