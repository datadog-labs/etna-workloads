Reproducer: builds a Float16 column (incl. NaN/NULL) and runs Float16 + int / Float16 = int
queries (from the upstream float16.slt).
Clean: Float16 is coerced against the other numeric types, and both queries return rows.
Buggy (missing Float16 arm in numerical_coercion): the Float16 side is cast to Int8 instead,
so both queries fail with "Cast error: Can't cast value NaN to type Int8".
