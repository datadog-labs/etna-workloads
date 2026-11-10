# Adapted injection for Suppress the error for private fields with non_exhaustive attribute

Fix: https://github.com/rust-lang/rust/commit/6a709e7195b819c2baef9cba2c889d5408346b48

# Rationale
compiler/rustc_hir_typeck/src/expr.rs, check_expr_struct_fields (`StructTailExpr::None` arm): removed the
`&& !variant.field_list_has_applicable_non_exhaustive()` condition, re-expressing the fix hunk
`@@ -2331,7 +2331,11 @@` (`} else if adt_kind != AdtKind::Union && !remaining_fields.is_empty()` gained
`&& !variant.field_list_has_applicable_non_exhaustive()`). The private-fields error is again emitted
alongside the non-exhaustive error.
