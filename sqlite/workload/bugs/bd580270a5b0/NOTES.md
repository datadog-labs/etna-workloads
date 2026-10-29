Creates a WITHOUT ROWID table whose non-PK column b has COLLATE NOCASE, then runs a row-value
comparison `(a, b) <= ('BBB','CCC')`. Clean shell returns the row `BBB|a` (NOCASE: 'a' < 'CCC');
buggy shell uses BINARY collation for b in the PK index, so 'a' > 'CCC' and no row is returned.
