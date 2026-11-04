# Rationale

Fix (#13134) replaced the emulated "existence join" (LEFT join against a subquery projected with
a constant `true AS __exists`, tested with IS [NOT] NULL) by a native LeftMark join. The emulation
duplicates left rows when the subquery has duplicate matches.

55.2.0 keeps the native LeftMark join machinery everywhere (physical joins, proto, etc.), so only the
optimizer hunk is reversed, in `datafusion/optimizer/src/decorrelate_predicate_subquery.rs`:
- `mark_join` -> `existence_join`: projects `true AS __exists` onto the subquery, joins with
  `JoinType::Left`, and returns `__exists IS NOT NULL` (or `IS NULL` if negated) instead of the
  `mark` column / `!mark`. Reverses the fix's `existence_join`->`mark_join` hunk, plus the
  `iter`/`chain` imports and docs. The call sites in `rewrite_inner_subqueries` are renamed.
  (`lit` was already imported in 55.2.0.)

Other fix hunks (LeftMark join type, physical joins, proto, etc.) are left alone: they are
the feature, and the bug returns by no longer using it.

Oracle: `subquery.slt` fails. Plans for EXISTS/IN subqueries under OR show `Left`/`Right` joins
with `__exists IS NOT NULL` instead of `LeftMark`/`RightMark`, and (per the fix's tests)
duplicate subquery rows duplicate outer rows.
