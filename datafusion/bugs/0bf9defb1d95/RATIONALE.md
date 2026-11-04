# Rationale

55.2.0 already contains the fix for bug 1 in its fixed form and a refactored `build_join`; I re-introduced bugs 1 and 3. Bug 2 (qualifying the CASE columns) is not reverted.

## datafusion/optimizer/src/decorrelate.rs, `remove_duplicated_filter`
Reverses the fix hunk that parenthesised the predicate. Restores the old precedence `(op==op && l==l && r==r) || (l==r && r==l)`. Two filters with different operators but swapped operands (e.g. `id = x` vs `x > id`) are now treated as duplicates and dropped from the join filters. The `assert_or_internal_err!` and `Result` return stay, since the assert is a documentation/check addition and not the behaviour.

## datafusion/optimizer/src/scalar_subquery_to_join.rs
Reverses the hunks that changed the count-bug map key from the column name to the qualified `Column`. `build_join` returns `HashMap<String, Expr>` keyed by the bare name, and the two `transform_up` lookups use `col.name`. The parent query's unrelated column that shares a name with the subquery aggregate alias is therefore rewritten to the CASE expression.

## Oracle failures (subquery.slt)
- The `SELECT sq_name_t1.id * 10 + (SELECT count(*) AS id ...)` query returns 22/11/0 instead of 12/21/30, because the outer `sq_name_t1.id` was replaced by the CASE.
- The `WHERE sq_name_t1.id > (SELECT count(*) AS id ...)` and projection cases are affected the same way.
- The query at slt line 2579 also fails (0 instead of 2). It comes from the same name-only match, since `c_acctbal`-style names collide with the aliases.
