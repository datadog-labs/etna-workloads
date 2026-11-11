# Adapted injection for Properly normalize types in bck when checking pointer casts

Fix: https://github.com/rust-lang/rust/commit/a1f20f17c86a7a0a51728be48afd121d5ae2df64

# Rationale
File: compiler/rustc_borrowck/src/type_check/canonical.rs, fn `struct_tail` (used by the PtrToPtr cast check in type_check/mod.rs).
Fix hunk `@@ -2320,8 +2320,11 @@` replaced `struct_tail_without_normalization` with `struct_tail_with_normalize(.., &mut normalize, ..)` where `normalize = |t| self.normalize(t, location)`.
In 1.99.1 the check goes through `struct_tail`, which uses that normalizing closure; I replaced the closure with an identity (`skip_norm_wip`), restoring the no-normalization behaviour, so projections like `<T as Id>::Id` hide the dyn tail.
