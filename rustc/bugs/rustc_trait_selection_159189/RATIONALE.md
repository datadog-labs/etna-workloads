# Adapted injection for Account for type alias projections in E0308 "expected/found" shortening logic

Fix: https://github.com/rust-lang/rust/commit/60bf4db59715edbb56589f72a0bff0f460216d84

# Rationale
One hunk: compiler/rustc_trait_selection/src/error_reporting/infer/mod.rs, `TypeErrCtxt::cmp`.
Removed the two `(ty::Alias(kind1, alias1), ty::Alias(kind2, alias2))` match arms (the identical-alias arm producing `_`, and the Projection arm that prints `<Self as Trait<args>>::Name<args>` via `compare_generics`, highlighting only differing parts).
This re-expresses fix.diff hunk `@@ -1309,9 +1362,83 @@` which added those arms. Without them, aliases fall to the `_` arm (`maybe_highlight`), i.e. whole-type highlighting, the pre-fix behaviour.
The other fix hunks (compare_generics/recurse/maybe_highlight refactor, verbose guard) are already in/neutral in 1.99.1 and were left untouched (the helpers remain, now used only by the ADT path).
