# Adapted injection for not use offset when there is not ends with brace

Fix: https://github.com/rust-lang/rust/commit/594fa01aba7aa48990ffb673eb6d46be239f0193

# Rationale
File compiler/rustc_hir_analysis/src/check/mod.rs, fn `impl_suggestion_span` (the code moved out of `missing_items_err` in 1.99.1).
Re-expresses fix hunk `@@ -211,11 +211,18 @@ fn missing_items_err(`: removed the `span_to_snippet(...).ends_with("}")` check and the `shrink_to_hi()` fallback, restoring the unconditional `hi = full_impl_span.hi() - BytePos(1)` offset. For `impl T for S；` (multi-byte non-brace ending) this subtracts 1 byte inside a char, giving a bad span.
