# Adapted injection for resolve: mark it undetermined if single import is not has any bindings

Fix: https://github.com/rust-lang/rust/commit/f67a0eb2b72294f108051381cbc833c295aadad9

# Re-injection rationale

File: compiler/rustc_resolve/src/ident.rs, fn `single_import_can_define_name` (1.99.1 successor of the code in `resolve_ident_in_module_unadjusted`'s single-import loop).

1. Removed the `if source != target { if decls.iter().all(|d| d.get().decl().is_none()) { return true } else if decls[ns]... && binding.is_some() { return true } }` block.
   Re-expresses fix hunk `@@ -979,15 +994,25 @@` (added: `if binding.map_or(false, |b| b.module().is_some()) && source_bindings.iter().all(|b| matches!(b.get(), Err(Undetermined))) { return Err((Undetermined, Weak::No)); }`), i.e. "mark it undetermined if the single import has no bindings yet". Without it the glob binding is accepted early. Unused `target`/`decls` bindings dropped.
2. `Err(Determined) | Err(Undetermined) => continue` and `Ok(_) => return true` (was `Ok(_) | Err(Undetermined) => return true`).
   Same hunk: the fix's whole point is returning Undetermined when the single import's source is still undetermined; here an Undetermined source no longer blocks the glob. (Needed because 1.99.1's cycle detector alone masks removal of 1.)

Result: shadow-glob-module-resolution-1/-2 fail (the `cannot determine resolution` diagnostics change).
