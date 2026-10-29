Table t0(c0 TEXT UNIQUE) holds '-1'. `WHERE - x'ce' >= t0.c0` (and `- 'ce'`) should return the row, because
the unary minus yields integer 0, which is converted to text '0' >= '-1'.
The buggy shell treats the negated blob/string as needing no affinity change, so the comparison
is made with the integer 0 against the text and the row is not returned (empty result vs `-1|`).
