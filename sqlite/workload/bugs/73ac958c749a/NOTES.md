repro.sql is test bloom1-1.4/1.5 as plain SQL. A three-table join uses a bloom filter on `t2.c = t1.b`, where c is INTEGER PRIMARY KEY and b is TEXT ('123').
Clean shell prints `result`. The buggy shell prints nothing, because the missing OP_MustBeInt means the text value is hashed into the filter without being coerced to an integer. The filter then wrongly rejects the matching row.
