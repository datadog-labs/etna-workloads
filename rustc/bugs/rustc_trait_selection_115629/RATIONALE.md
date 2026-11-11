# Adapted injection for Don't suggest dereferencing to unsized type

Fix: https://github.com/rust-lang/rust/commit/ee9727e263f32d1bc3aa5b8fdbe42098e84aa923

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, `suggest_dereferences` (FunctionArg branch, autoderef `position` closure).

The fix hunk `@@ -838,7 +838,20 @@ ...` added a `Sized` check (`sized_obligation` / `predicate_must_hold_modulo_regions`) next to `predicate_may_hold(&obligation)` so a deref to an unsized type is not suggested. In 1.99.1 that guard lives in the closure as `can_deref && ...` (can_deref = under ref / Copy / numeric / boxed+sized). I disabled it (`let _ = can_deref;`), so the suggestion is accepted for unsized derefs (e.g. `*i` for `&dyn IntoIterator`) again.
