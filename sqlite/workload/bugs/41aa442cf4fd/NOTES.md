Table t4(b COLLATE nocase) with 'abc','ABC','aBC'. `WHERE b='abc' ORDER BY b COLLATE binary`
should return ABC, aBC, abc (binary order). The buggy shell treats the ORDER BY term as redundant
because of the == constraint, ignoring the collation mismatch, so it skips sorting and returns rows in insertion order.
