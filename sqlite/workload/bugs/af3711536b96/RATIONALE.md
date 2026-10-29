# Rationale

## Changed hunk: `substExpr()` in `tree/src/select.c`

The fix replaced the manual marking of the substituted expression's root
node (`iRightJoinTable` + `EP_FromJoin`) with `sqlite3SetJoinExpr()`, which marks
the whole subtree. In 3.54.1 the field is `w.iJoin` and the flags are
`EP_OuterON|EP_InnerON`. I restored the pre-fix form: copy `w.iJoin` and set the
flag(s) on `pNew` only, not on its subexpressions. If `pNew` is an AND, the
WHERE-clause splitter separates the children, which lack the ON-clause marking
and so get treated as ordinary WHERE terms.

## Oracle failure

`join-25.1` (`SELECT count(*) FROM v0 LEFT JOIN t0 ON v0.c0` with
`v0.c0 = (NULL AND 5)`) fails. The other 198 cases pass.
