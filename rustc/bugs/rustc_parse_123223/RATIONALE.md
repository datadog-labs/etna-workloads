# Adapted injection for Fix invalid silencing of parsing error

Fix: https://github.com/rust-lang/rust/commit/e572a194bf76957fa41495aa13f9925df6e632b2

# Rationale
File `compiler/rustc_parse/src/lexer/mod.rs`, fn `report_unknown_prefix` (single logical change, re-expressing both hunks of fix.diff).

- Fix hunk 1 (`@@ -698,7 +698,6 @@`, removed `let mut silence = false;`): re-added `let mut silence = false;`.
- Fix hunk 2 (`@@ -706,25 +705,20 @@`): removed the `let end = ... && !is_multiline(start.until(end))` guard, restored `silence = true;` in the MeantStr branch, and restored the `if silence { create_err(err).delay_as_bug() } else { emit_err(err) }` ending, so the unknown-prefix error is silently dropped (assuming an unclosed-char error follows, which may never be emitted, e.g. in macro definitions).
