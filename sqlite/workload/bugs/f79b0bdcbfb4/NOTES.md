repro.sql runs quote() on +Inf/-Inf (4.2e+859, -7.8e+904). Clean shell prints 9.0e+999|-9.0e+999; buggy shell prints Inf|-Inf (not valid SQL literals). Exit status is 0 in both.
