# Adapted injection for Don't allow repeat expr count inference side effects to propagate

Fix: https://github.com/rust-lang/rust/commit/f60bab475e47e84bb188e463b6a17894a57092c4

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, fn `check_repeat_exprs`.
Removed the `.collect::<Vec<_>>()` (and its comment) after the `flat_map` that structurally resolves each repeat count.
Re-expresses fix hunk `@@ -104,24 +104,53 @@ ... check_repeat_exprs`, which introduced
`// We collect to force the side effects of structurally resolving the repeat count to happen in one go` / `.collect::<Vec<_>>()`.
Without it the iterator is lazy, so each repeat expr is resolved and its `Copy` bound enforced one at a time. Inference side effects from one `Copy` check can then affect whether later repeat counts are known, which is the pre-fix behaviour.
