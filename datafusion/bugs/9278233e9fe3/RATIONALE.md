# Rationale

Bug: `count(*)`/`count()` is planned to `count(Int64(1))`, and the name `count(*)` came from a
`Count::schema_name` special case that treats any `count(1)` as `count(*)`. So `count(*)` and
`count(1)` in one query got the same schema name ("duplicated schema name" error). The fix
removed those overrides and made the planners preserve the original name with `NamePreserver`.

Hunks reversed (55.2.0 already has the fix form, so both halves are reverted):

1. `functions-aggregate/src/count.rs`: re-added `is_count_wildcard` and the `schema_name` /
   `window_function_schema_name` overrides on `Count`, which render `count(*)` for `count()` and
   `count(<Int64 literal>)`. They reuse the `udaf_default_*` helpers (the old code inlined that
   logic), so the output is the same. The `display_name` overrides were not restored because
   `human_display` has since replaced that path.
2. `functions-aggregate/src/planner.rs`: removed the `NamePreserver` save/restore, as before the fix.
3. `functions-window/src/planner.rs`: same for the window planner.

Oracle failures: `./check.sh` fails every oracle slt file. Plans show `count(*)` where the
expected output is `count(Int64(1))` (e.g. union.slt:705, window.slt:4252, subquery.slt:1019).
