# Adapted injection for Fix missing self subst when rendering Fn* trait with no output type

Fix: https://github.com/rust-lang/rust/commit/431b9aa38ff466fbed1b933cd17efa10f6cd03b4

# Rationale
File: compiler/rustc_middle/src/ty/print/pretty.rs, fn pretty_print_opaque_impl_type (the `else` branch "render this like a regular trait").
Fix hunk `@@ -1093,9 +1093,13 @@` changed the trait ref to `[self_ty, Ty::new_tup(tcx, args)]` (adding the missing Self subst). Re-injected: the self_ty is ignored again and the trait ref is built as `[Ty::new_tup(tcx, args)]`, so a `FnOnce<()>` with no output renders a trait ref lacking the self arg (ICE when printed). The other fix hunks (type plumbing of self_ty) are left in place, as they are harmless without this use.
