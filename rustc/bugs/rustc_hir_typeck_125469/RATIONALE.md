# Adapted injection for Don't skip inner const when looking for body for suggestion

Fix: https://github.com/rust-lang/rust/commit/c58b7c9c81cf150bf307ca13375f12fb1c8f6420

# Hunk: compiler/rustc_hir_typeck/src/coercion.rs, CoerceMany::coerce_inner (the "maybe we forgot a `return`/`break`" block)
Re-expresses both hunks of fix.diff (`@@ -1871,11 +1871,8 @@` and `@@ -1884,7 +1881,7 @@`).
The fix replaced `parent_iter(block_or_return_id).find_map(|(_, node)| Some((node.fn_decl()?, node.associated_body()?.0)))`
with the fn decl of `fcx.body_id` and passed `fcx.body_id` instead of `parent_id`.
In 1.99.1 the fixed code used `fcx.body_def_id`; I restored the old parent-walk (`hir_parent_iter` + `find_map`) and pass `parent_id`.
The walk skips an inner `const` (it has a body but no fn_decl) and finds the outer fn, so the suggestion is built from the wrong body.
