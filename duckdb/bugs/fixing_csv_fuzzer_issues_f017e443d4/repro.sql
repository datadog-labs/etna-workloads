SET threads=1;
FROM read_csv('data/csv/afl/5194/crashes/case_0.csv', auto_detect=false, buffer_size=8, columns={'a': 'integer','b': 'integer','c': 'integer'}, header=true, maximum_line_size=0);
