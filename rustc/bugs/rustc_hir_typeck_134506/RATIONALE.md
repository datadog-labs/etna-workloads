# Adapted injection for Remove a duplicated check that doesn't do anything anymore.

Fix: https://github.com/rust-lang/rust/commit/987656f5096c89377d4b58cda5e659f21437001f

# Rationale
File: compiler/rustc_hir_typeck/src/coercion.rs, fn `try_find_coercion_lub`.
Re-added the loop removed by fix.diff hunk `@@ -1315,43 +1315,6 @@ impl<'a, 'tcx> FnCtxt<'a, 'tcx>`
("Then try to coerce the previous expressions to the type of the new one ... for expr in exprs { ... noop ... return Err(... lub ...)").
It sits right before `let ok = ... coerce.coerce(prev_ty, new_ty)`. `as_coercion_site()` dropped since exprs are plain `&Expr` in 1.99.1.
Effect: the duplicated check returns the LUB error before the proper path, giving an ICE (assertion) on the test instead of the mismatched types error.
