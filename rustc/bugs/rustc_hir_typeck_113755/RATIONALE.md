# Adapted injection for Normalize lazy type aliases when probing for ADTs

Fix: https://github.com/rust-lang/rust/commit/c856c74764006610e23de4210a17dfb7a1702127

# Rationale
File compiler/rustc_hir_typeck/src/fn_ctxt/mod.rs, fn `probe_adt` (AstConv/HirTyLowerer impl).
Removed `ty::Free { .. }` (the weak/lazy type alias kind) from the alias pattern so lazy type aliases are no longer normalized when probing for ADTs.
Re-expresses fix hunk `@@ -302,7 +302,9 @@ impl AstConv for FnCtxt`: `ty::Alias(ty::Projection | ty::Inherent | ty::Weak, _)` (Weak was added by the fix; now named Free).
