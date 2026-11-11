# Adapted injection for reject projecting to fields whose offset we cannot compute

Fix: https://github.com/rust-lang/rust/commit/9ef1e351665d9023483f4c281903848421319007

# Rationale
File: compiler/rustc_const_eval/src/interpret/projection.rs, `project_field`.
Re-expresses fix hunk `@@ -174,12 +174,15 @@` (const_eval projection.rs): the fix split the `None` arm into
`None if offset == Size::ZERO => (base_meta, offset)` and a `None => throw_unsup...(extern type has no known offset)`.
Reinjected: a single `None => (base_meta, offset)` arm, i.e. no adjustment and no error for fields at unknown offsets, so
projecting to a non-zero-offset extern-type tail field succeeds in const eval.
The codegen_ssa place.rs hunks are not reverted (that file moved; the const-eval hunk alone makes the oracle fail).
