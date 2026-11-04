`repro.sql` runs `COPY (SELECT 1 AS id WHERE FALSE) TO 'table_no_rows.parquet'`, then creates an external Parquet table on that file and counts its rows.

- **df-clean:** the COPY writes a 0-row Parquet file, and the count query returns 0.
- **df-buggy:** the COPY reports 0 rows but writes no file. CREATE EXTERNAL TABLE then fails with "No files found ... Cannot infer schema from an empty location", and the SELECT fails with "table 't' not found". The exit status is the same on both builds, but the output differs.
