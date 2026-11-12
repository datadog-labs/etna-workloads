.mode list
.nullvalue NULL
SELECT * FROM repeat_row(0, num_rows=3);
SELECT * FROM repeat_row(NULL, 1, "52", true, num_rows=2);
SELECT * FROM repeat_row('hello', num_rows=2);
SELECT * FROM repeat_row(1, num_rows=0);
SELECT * FROM repeat_row(1, num_rows=10000);
SELECT * FROM repeat_row(1);
SELECT * FROM repeat_row(num_rows=3);
SELECT * FROM repeat_row();
SELECT * FROM repeat_row(1, num_rows=NULL);
SELECT * FROM repeat_row(1, num_rows=-1);
