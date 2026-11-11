# Adapted injection for Remove unnecessary layout assertions for object-safe receivers

Fix: https://github.com/rust-lang/rust/commit/0b26dc0b51c87a90ce61f50dd7141ff451513b23

# Rationale
All changes in compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs, re-adding what the fix removed:
- imports (`std::iter`, `rustc_abi::BackendRepr`, `ExistentialPredicateStableCmpExt as _`): fix hunk `@@ -4,19 +4,16 @@`.
- `dyn_compatibility_violations_for_trait`: re-added `if violations.is_empty() { ... check_receiver_correct(...) }` (fix hunk `@@ -109,14 +106,6 @@`).
- re-added `check_receiver_correct` (layout assertions: unit receiver must be Scalar, dyn receiver must be ScalarPair, via span_delayed_bug) (hunk `@@ -499,55 +488,6 @@`).
- re-added `object_ty_for_trait` (hunk `@@ -569,49 +509,6 @@`).
Adapted to current APIs (skip_norm_wip, ScalarPair { .. }, new_dynamic without ty::Dyn).
