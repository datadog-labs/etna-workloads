\c "dbname=postgres replication=database"
BASE_BACKUP (LABEL 'x', TARGET 'blackhole', COMPRESSION 'gzip', COMPRESSION_DETAIL 'level=-1');
