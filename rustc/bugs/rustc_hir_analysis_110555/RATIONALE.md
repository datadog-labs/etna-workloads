# Adapted injection for Format missing GATs correctly

Fix: https://github.com/rust-lang/rust/commit/f362f6e9e6cb5d55bbac6a94353209c3e3a2ebb5

# Rationale
File: compiler/rustc_hir_analysis/src/check/mod.rs, fn suggestion_signature, `ty::AssocKind::Type { .. }` arm.
Re-expresses fix hunk `@@ -466,7 +466,13 @@ fn suggestion_signature`: the fix replaced
`ty::AssocKind::Type => format!("type {} = /* Type */;", assoc.name)` with a version computing generics/where-clauses
from the assoc type's predicates. I restored the old form (no generics or where clauses), so missing GATs are formatted incorrectly.
