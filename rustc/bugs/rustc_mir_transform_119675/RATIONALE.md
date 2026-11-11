# Adapted injection for Skip threading over no-op SetDiscriminant.

Fix: https://github.com/rust-lang/rust/commit/41eb9a49aff07255f0cc28f6e435527a4435714a

# Rationale
File: compiler/rustc_mir_transform/src/jump_threading.rs, `TOFinder::process_statement`, `StatementKind::SetDiscriminant` arm, plus `use rustc_abi::{TagEncoding, Variants}`.

Re-expresses fix.diff hunk `@@ -391,8 +392,25 @@ impl<'tcx, 'a> TOFinder` (the `writes_discriminant` check: Single / Direct => true, Niche => `*variant_index != untagged_variant`; thread only `if writes_discriminant`) and the import hunk `@@ -43,6 +43,7 @@` (`use rustc_target::abi::{TagEncoding, Variants}`).

Note: 1.99.1 had since changed semantics (a no-op SetDiscriminant is UB, so it threads anyway). Re-adding the guard makes JumpThreading skip threading over a niche-untagged SetDiscriminant, so the oracle test (expects `goto`) fails.
