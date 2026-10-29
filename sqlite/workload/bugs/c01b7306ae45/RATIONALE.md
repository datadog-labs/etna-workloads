# Rationale

Fix hunk reversed: the `sqlite3SelectExpand()` change in `src/select.c`, which added a first
Walker pass using `convertCompoundSelectToSubquery` before `selectExpander`.
In 3.54.1 that pass is guarded by `pParse->hasCompound`. I removed the whole guarded
block, so only the `selectExpander` pass runs, as before the fix. The function
`convertCompoundSelectToSubquery` itself (the fix's other hunk) is left in place. It is now
unused, but it is `static` and the build still succeeds.

Without the rewrite, a compound SELECT whose ORDER BY has a COLLATE term goes to the
merge algorithm, and that collation leaks into the EXCEPT/UNION comparison.

Failing oracle cases (test/selectE.test): selectE-1.0 (got `ghi`, wanted `def ghi`),
selectE-1.1 (got `abc`, wanted `abc DEF`), selectE-2.2 (got `ABC GHI`, wanted empty).
