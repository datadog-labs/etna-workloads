# Adapted injection for safe transmute: forbid reference lifetime extension

Fix: https://github.com/rust-lang/rust/commit/17995d5cc2e75b65b8bd6b77ad30b0c764500c0c

# Rationale
File: compiler/rustc_transmute/src/maybe_transmutable/mod.rs, `answer_memo` (refs_answer closure `is_transmutable`).
Removed the `if !self.assume.lifetimes { conditions.push(Condition::Outlives { long: src.region, short: dst.region }) }` push, so reference lifetime extension is no longer checked.
This re-expresses the fix's addition of the lifetime-outlives check for references (fix hunks in layout/tree.rs, layout/mod.rs, maybe_transmutable/mod.rs `@@ -45,10 +45,9 @@`, confirmation.rs Outlives handling), reduced to the core: the Outlives condition when `Assume::lifetimes` is false.
