# Rationale

Fix #12341 made `NamePreserver` remember and restore the *qualified* name
(relation + name) of an expression; before it only the unqualified name was
kept and restored with `alias_if_changed`.

Changed: `datafusion/expr/src/expr_rewriter/mod.rs`
- `NamePreserver::save`: saves `expr.schema_name()` with `relation: None` (pre-fix: `name_for_alias()` only, no qualifier).
- `SavedName::restore`: compares `schema_name()` to the saved name, ignoring
  the relation, as the old `alias_if_changed(name)` did.

The effect is that a rewrite changing only the qualifier (e.g. `test.a` ->
unqualified column `"test.a"`) is not re-aliased, so the output field's
qualifier changes.

Oracle: select.slt, case `SELECT "test.a" FROM (SELECT a AS "test.a" FROM test)`
(issue #12183) is expected to fail with a field-resolution/schema error.
