# Adapted injection for Fix parsing of frontmatters with inner hyphens

Fix: https://github.com/rust-lang/rust/commit/55f59fb0e329d0815a06d51dd469d774eb455cba

# Rationale
File compiler/rustc_lexer/src/lib.rs, `Cursor::frontmatter`. In 1.99.1 the closing-fence search was rewritten to `find("\n---")`, which is immune to the original bug. I restored the pre-fix scanning loop: find a run of dashes, accept it only if only whitespace precedes it on its line, and otherwise advance `s`. Closing is bumped with `self.bump_bytes(closing)` and without the accumulated offset.

This re-expresses both fix hunks:
- `@@ -545,11 +545,12 @@` `self.bump_bytes(size + closing)` is back to `self.bump_bytes(closing)`. `size` is computed but never used (`let _ = size;`).
- `@@ -562,6 +563,7 @@` the `size += closing + length_opening` accumulation exists but is not applied to the bump.

Result: `x ---y\n---` bumps by an offset relative to the shortened slice, so the token ends too early (#141483).
