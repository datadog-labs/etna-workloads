# Adapted injection for don't recover `&raw EXPR` as a missing comma

Fix: https://github.com/rust-lang/rust/commit/b459cfcf439c084ed12233e49001a990293f6e8b

# Rationale
Hunk 1: compiler/rustc_parse/src/parser/mod.rs, `expect_one_of`-style separator recovery in `parse_seq_to_before_tokens`
(the "Attempt to keep parsing if it was an omitted separator" site). Removed the early
`if exp.token_type == TokenType::Comma && self.is_expected_raw_ref_mut() { return Err(expect_err); }`
which re-expresses fix hunk `@@ -917,6 +917,17 @@` (added `&raw <expr>` check returning `Err(expect_err)`). Without it, `&raw x` is recovered as a missing comma, restoring the bug.
The expr.rs hunk (call-arg recovery, `@@ -1279,9 +1279,25 @@`) left in place; it's not needed to reintroduce the bug.
