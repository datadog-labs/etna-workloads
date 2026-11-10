# Adapted injection for Use MaybeCause::or to allow constraints from overflows if they are combined with ambiguity

Fix: https://github.com/rust-lang/rust/commit/a910329c671aea4342413ecd8f88f09e47f8b85a

# Rationale
File: compiler/rustc_type_ir/src/solve/mod.rs, `MaybeCause::or` (two Ambiguity/Overflow mixed arms).
Re-expresses the fix hunk `@@ -289,19 +289,58 @@ pub enum MaybeCause` which added `or` with
"When combining ambiguity + overflow, we can keep constraints" -> `keep_constraints: true`.
Now those arms yield `keep_constraints: false`, so overflow+ambiguity responses drop constraints again
(as before the fix, when overflow always discarded constraints in canonical.rs/eval_ctxt).
