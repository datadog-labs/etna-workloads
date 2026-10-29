repro.sql: rowvalueA-5.2. Table with a NOCASE two-column index, query with a row-value range
`('B' COLLATE nocase,'abc')>(a,b)`. Clean shell returns both rows (a|NULL, b|ABCD); the buggy
shell picks the wrong collation for the 2nd term of the vector range and returns a different result.
