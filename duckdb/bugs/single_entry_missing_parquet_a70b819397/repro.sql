CREATE TABLE t(a VARCHAR);
COPY t FROM 'data/csv/broken/test.csv.zst' (COMPRESSION UNKNOWN);
