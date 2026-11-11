# Adapted injection for don't replace opaque types under binders with infer vars

Fix: https://github.com/rust-lang/rust/commit/2e83a72964ce15eedb30471c1b92b2a9c3dd60a9

# Rationale
File: compiler/rustc_infer/src/infer/opaque_types/mod.rs, `InferCtxt::replace_opaque_types_with_inference_vars` (moved from opaque_types.rs).
Removed `&& !ty.has_escaping_bound_vars()` from the match guard, so opaque types under binders get replaced with infer vars again.
Re-expresses fix hunk `@@ -64,7 +64,7 @@`: `if replace_opaque_type(def_id) && !ty.has_escaping_bound_vars() =>` -> without the extra check.
