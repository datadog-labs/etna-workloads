# Adapted injection for Properly handle closure<->closure and fndef<->fndef coerce-lubs

Fix: https://github.com/rust-lang/rust/commit/2676c9363c053302492770ecf429bbd8a6a0b172

# Rationale
All changes are in `try_find_coercion_lub` in compiler/rustc_hir_typeck/src/coercion.rs (fix hunk `@@ -1193,34 +1194,51 @@`, which added `lubbed_tys` with `self.leak_check(outer_universe, Some(snapshot))?` and a `(ty::Closure, ty::Closure) => match lubbed_tys()` arm).
1. Removed `outer_universe` and `self.leak_check(...)` from the lub closure (commit_if_ok now takes `|_|`). This restores the old fndef<->fndef lub without a leak check.
2. Narrowed the lub arm to `(FnDef, FnDef)` only, and moved `(Closure, Closure)` back to the arm that goes straight to fn-ptr signature coercion. This matches the old behaviour (fix hunk `@@ -1233,16 +1251,8 @@`, where the old direct `(ty::Closure(..), ty::Closure(..)) => (Some(unclosure a), Some(unclosure b))` arm was removed).
