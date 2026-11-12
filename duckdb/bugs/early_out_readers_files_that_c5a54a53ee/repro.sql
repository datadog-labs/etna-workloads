select count(*) from read_csv('data/csv/union_by_name_2/*.csv', union_by_name=True, parallel=false);
