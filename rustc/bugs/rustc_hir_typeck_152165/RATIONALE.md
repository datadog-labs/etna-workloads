# Adapted injection for Normalize the whole `Place`

Fix: https://github.com/rust-lang/rust/commit/82b09a177c75a10c3a946a3299eb4a52e155ccf8

# Rationale
All changes in compiler/rustc_hir_typeck/src/upvar.rs. In 1.99.1 the fix's `deeply_normalize_place` is gone; places are normalized eagerly as whole `Place`s via `self.normalize(..)` in `place_for_root_variable` and the ExprUseVisitor delegate (`fake_read`, `consume`, `use_cloned`, `borrow`), and the old call sites at fix hunks `@@ -370` / `@@ -782` no longer normalize.

1. `place_for_root_variable`, `fake_read`, `consume`, `use_cloned`, `borrow`: eager whole-place `normalize` removed (back to plain clone), as in the parent where nothing was normalized at those points. Re-expresses the whole-place normalization the fix introduced (`resolved_place = self.resolve_vars_if_possible(place.clone()); ocx.deeply_normalize(.., resolved_place)`).
2. New `FnCtxt::try_structurally_resolve_place_ty`: the pre-fix per-type helper (the `-` lines of hunk `@@ -1132,24 +1132,19 @@`: `deeply_normalize` closure applied to `place.base_ty` and each `proj.ty` separately) restored.
3. Call at the closure_kind_origins site (`@@ -370,7 +370,7 @@`, `-self.try_structurally_resolve_place_ty(origin.0, &mut origin.1)`) restored.
4. The call in `compute_min_captures` (`@@ -782,7 +782,7 @@`) is NOT restored (normalization absent there). Caveat: restoring the per-type call there made the oracle pass on 1.99.1, so the failing state is "no normalization at that site" rather than exact parent behaviour.
