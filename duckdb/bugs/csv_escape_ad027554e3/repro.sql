SELECT * FROM read_csv('data/csv/escape.csv', auto_detect=false, columns={'a':'VARCHAR','b':'VARCHAR','c':'VARCHAR'}, header=false);
