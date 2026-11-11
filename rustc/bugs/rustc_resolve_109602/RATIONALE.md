# Adapted injection for fix(resolve): replace bindings to dummy for unresolved imports

Fix: https://github.com/rust-lang/rust/commit/f34678c0976086523f56a0f974e76cfc5ca2fc40

# Rationale
compiler/rustc_resolve/src/imports.rs, `import_dummy_binding`: re-expresses fix hunk
`@@ -405,11 +405,12 @@ ... fn import_dummy_binding(&mut self, import, is_indeterminate: bool)`:
the fix replaced `if target_bindings.iter().any(|b| b.get().is_some()) { return; }` with
`if !(is_indeterminate || ...all(is_none))`. I restored the old condition
`if decls.iter().any(|d| d.get().decl().is_some()) { return; }`, so indeterminate imports that
have a partial resolution get no dummy binding. The `is_indeterminate` parameter is left in place
(unused in the check; call-site hunk #2 is left unchanged). The Debug-derive hunks are not behavioural.
