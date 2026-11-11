# Adapted injection for Emit ForbiddenBound fatally if meeting complex bound

Fix: https://github.com/rust-lang/rust/commit/15032749bc1a7e28d8ec4634427f1f1ab9143256

# Rationale
File: compiler/rustc_ast_passes/src/feature_gate.rs, fn `check_late_bound_lifetime_defs`-style helper (the loop over `params` emitting `ForbiddenBound`).
Re-expresses fix hunk `@@ -149,7 +149,14 @@ impl<'a> PostExpansionVisitor<'a>`: removed the
`if param.bounds.iter().any(|bound| matches!(bound, GenericBound::Trait(_))) { ... emit_fatal ... } else { emit_err }`
branch, restoring an unconditional `emit_err(ForbiddenBound { spans })`. Also dropped the `GenericBound` import (hunk @@ -1,5 +1,5 @@).
