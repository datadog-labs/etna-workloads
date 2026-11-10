# Adapted injection for match scrutinee need necessary parentheses for structs

Fix: https://github.com/rust-lang/rust/commit/c44b35e1c37f819327861b9f4d77e1469b33f457

# Rationale
File compiler/rustc_lint/src/unused.rs, fn `UnusedDelimLint::lint_unused_delims`-helper `cant_be_removed`-style check (`fn ... followed_by_block` logic near line 219).
Removed the block "Check if we need parens for `match &( Struct { field: }) {}`" that peels `AddrOf` and returns true if `parser::contains_exterior_struct_lit(innermost)`.
This re-expresses the fix hunk `@@ -666,6 +666,24 @@ trait UnusedDelimLint` which added that block after `if !followed_by_block { return false; }`. Without it, `match (&mut S { .. })` wrongly gets unused-parens lint.
