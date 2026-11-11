# Adapted injection for rustc_middle: Pretty-print negative bounds correctly

Fix: https://github.com/rust-lang/rust/commit/977546d3fc9f48702046214749521da4c459f614

# Rationale
File: compiler/rustc_middle/src/ty/print/pretty.rs, fn `pretty_print_opaque_impl_type`.

1. Sizedness handling in the bounds loop. Re-expresses the fix hunk `@@ -922,13 +923,24 @@`
   (`match pred.polarity { Positive|Reservation => {has_sized_bound = true; continue;} Negative => has_negative_sized_bound = true }`).
   Buggy version: any polarity of `Sized` (including `!Sized`) sets `has_sized_bound` and is skipped, so `!Sized` is lost.
2. Negative-polarity printing. Re-expresses hunk `@@ -1023,11 +1039,15 @@`
   (`if polarity == ty::ImplPolarity::Negative { p!("!"); }`). Removed the `!` print, so `impl !Trait` prints as `impl Trait`.
