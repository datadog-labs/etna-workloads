# Adapted injection for add suggestion for associated function

Fix: https://github.com/rust-lang/rust/commit/e802180f416b1e30b70e605e4d950ea5e5564745

# Rationale
File compiler/rustc_hir_typeck/src/expr.rs, fn no_such_field_err: removed the block
"// Check if there is an associated function with the same name." (inherent_impls loop that labels
"this is an associated function, not a method", adds note/span_note/multipart_suggestion "use associated function syntax instead" and returns err).
Re-expresses the sole implementation hunk `@@ -3369,6 +3369,40 @@` of fix.diff, which added that block (reversed = removed).
