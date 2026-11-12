SELECT * FROM read_csv('data/csv/blank_line.csv', columns={'a':'VARCHAR'}, header=false, nullstr=['','','']);
