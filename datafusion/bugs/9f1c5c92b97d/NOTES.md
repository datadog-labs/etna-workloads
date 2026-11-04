Reproducer: CTAS with an explicit column schema over a join whose two sides both expose a column named `column1`.
Clean build creates the table and returns `1 | 2`. The buggy build loses the source qualifiers in the CTAS cast projection, so the statement fails with an ambiguous/duplicate column error.
