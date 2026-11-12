select count(*) from read_csv('data/csv/quoted_comment_buffer_boundary.csv', buffer_size=30, delim=';', header=false, null_padding=true, union_by_name=false, ignore_errors=true);
