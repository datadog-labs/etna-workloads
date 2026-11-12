select * from read_csv('data/csv/auto/int_bol.csv', auto_detect=false, columns={'a':'varchar'}, types=['BIGINT', 'DATE']);
