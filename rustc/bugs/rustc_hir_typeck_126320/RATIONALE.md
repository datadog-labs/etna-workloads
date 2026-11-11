# Adapted injection for Avoid follow-up errors on erroneous patterns

Fix: https://github.com/rust-lang/rust/commit/2733b8ab8d4407086eb41d615395a9a323a8fd77

# Hunk: compiler/rustc_hir_typeck/src/pat.rs, check_pat_tuple_struct
Removed the `if let Err(e) = had_err { on_error(e); return Ty::new_error(tcx, e); }` block after the subpattern loop in the matching-arity branch.
Re-expresses fix hunk `@@ -1249,6 +1244,10 @@` which added `if let Some(e) = had_err { on_error(e); return Ty::new_error(tcx, e); }`.
So after a type mismatch on the tuple-struct pattern, the pattern keeps its type instead of erroring, causing follow-up errors (the bug). The other hunks (had_err type change) are just plumbing in 1.99.1 (already Result).
