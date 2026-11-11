# Adapted injection for On "this .clone() is on the reference", provide more info

Fix: https://github.com/rust-lang/rust/commit/a754fcaa43e02472ff9e1971e0e7085f58a6f041

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, fn suggest_deref_or_ref-adjacent `suggest_clone_on_ref`-style helper (the "`X` does not implement `Clone`, so `&X` was cloned instead" logic).

Removed the loop over the unsatisfied `Clone` impl-bound errors that calls `err_ctxt().suggest_derive(...)` for each failing bound (e.g. `Day: Clone`).
Re-expresses fix hunk `@@ -1619,6 +1620,78 @@` , the part:
`for error in errors { if let ...Unimplemented = error.code && let Clause(Trait(pred)) ... { self.infcx.err_ctxt().suggest_derive(&error.obligation, diag, ...) } }`
i.e. "suggest `#[derive(Clone)]` also on type parameters to satisfy blanket implementations". Without it only `HashSet<Day>` is considered and no derive suggestion for `Day` is emitted.
