# Adapted injection for Do not ICE on invalid consts when walking mono-reachable blocks

Fix: https://github.com/rust-lang/rust/commit/82cc02a60bc09e31afa6cead8994a9e86b2a8012

# Rationale
File compiler/rustc_middle/src/mir/mod.rs, fn `Body::try_const_mono_switchint`.
Re-expresses all three fix hunks:
- `@@ -701,10 +701,7 @@`: closure `eval_mono_const` again returns `u128` and calls `bug!("Couldn't evaluate constant ...")` when `try_eval_bits` returns None (instead of returning the Option).
- `@@ -714,7 +711,7 @@` and `@@ -748,7 +745,7 @@`: call sites go back from `eval_mono_const(constant)?` to `eval_mono_const(constant)`.
