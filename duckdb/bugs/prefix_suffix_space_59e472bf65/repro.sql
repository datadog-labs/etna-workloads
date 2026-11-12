SELECT * FROM read_csv('data/csv/empty_space_start_value.csv', skip=1, header=false, columns={'a':'BIGNUM','b':'BIGNUM','c':'VARCHAR'});
