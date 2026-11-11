# Adapted injection for Make `unconditional_recursion` warning detect recursive drops

Fix: https://github.com/rust-lang/rust/commit/b4b33df983b4badac5c2578756cd42a76236be8d

# Rationale
File: compiler/rustc_mir_transform/src/lib.rs, pass list (run_runtime_lowering/analysis passes).
Removed `&Lint(check_call_recursion::CheckDropRecursion)` (and its comment) after `ElaborateDrops`.
Re-expresses fix hunk `@@ -446,6 +446,10 @@ fn mir_drops_elaborated_and_const_checked` which added
`rustc_mir_build::lints::check_drop_recursion(tcx, &body);` after drop elaboration. In 1.99.1 the lint
moved to check_call_recursion.rs and is run as a MIR lint pass; without it, recursive Drop impls are not warned about.
