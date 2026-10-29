Parent p has UNIQUE(b,c); child c references p(c,b) (reversed column order).
Row ('y','x') is valid, ('x','y') is not. PRAGMA foreign_key_check should report
only c row 2. The buggy shell ignores the column mapping (uses the wrong child
column order), so the valid row is reported as a violation and/or the invalid one is missed.
