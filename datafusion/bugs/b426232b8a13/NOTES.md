repro.sql runs RANGE window frames ordered by a DECIMAL column (the reporter's query, plus a DECIMAL(10,2) case with 1 PRECEDING AND 1 FOLLOWING).
Clean build: returns results (count 1; frame first/last values 1.50/2.50, 1.50/3.50, 2.50/3.50).
Buggy build: both queries fail with "Internal error: Uncomparable values: Decimal128(...)", because ScalarValue::partial_cmp requires equal precision for decimals, and the frame-bound arithmetic widens precision by 1.
