`repro.sql` creates t1(x) holding 'b' and 'B', then runs `x COLLATE nocase BETWEEN 'a' AND 'c'` (plain and with `+x`).
Clean returns `b B` for each query. Buggy returns only `b` for each, because the BETWEEN code loses the COLLATE on the left operand (the TK_REGISTER/op2 handling in sqlite3ExprCollSeq).
