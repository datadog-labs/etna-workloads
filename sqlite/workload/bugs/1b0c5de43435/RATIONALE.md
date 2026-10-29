# Rationale

Fix hunk reversed: `src/resolve.c` in `lookupName()`, the added
`if( IN_RENAME_COLUMN ){ sqlite3RenameTokenRemap(pParse, 0, (void*)pExpr); }`
in the result-set-alias match branch (just before `goto lookupname_end`).
In 3.54.1 the guard is spelled `IN_RENAME_OBJECT`. I removed the whole block, which is the pre-fix code.

Without the call, the token for an identifier that resolves to a result-set alias
(`d` in `... AS d FROM xxx WHERE d=0`) stays in the rename token list. It is then
treated as a reference to the renamed column and overwritten.

The assert hunks in alter.c are not reverted. They are only assertions and don't change behaviour.

Oracle failure: `altercol-15.2`. After `ALTER TABLE xxx RENAME a TO xyz`, the view
SQL comes out with the alias in WHERE rewritten too, instead of
`CREATE VIEW vvv AS SELECT xyz AS d FROM xxx WHERE d=0`.
