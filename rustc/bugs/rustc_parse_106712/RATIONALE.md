# Adapted injection for make error emitted on `impl &Trait` nicer

Fix: https://github.com/rust-lang/rust/commit/e590b934998c85175b85cb13842163a27a221dc7

# Rationale
File compiler/rustc_parse/src/parser/ty.rs, fn parse_generic_bounds_common.
Re-expresses fix hunk `@@ -727,11 +727,13 @@ impl<'a> Parser<'a>` (parse_generic_bounds loop), which added `|| self.token.can_begin_type()` to the bound loop condition. I removed `self.token.can_begin_type()` from the loop condition, so `impl &Trait` is no longer routed to the "expected a trait, found type" recovery in parse_generic_bound.
