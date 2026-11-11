# Adapted injection for Check elaborated projections from dyn don't mention unconstrained late bound lifetimes

Fix: https://github.com/rust-lang/rust/commit/ae5f58d906e755bff56dd9667c1d8b13ca236286

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs (file was renamed from dyn_compatibility.rs), in `lower_trait_object_ty`.
Removed the call `self.check_elaborated_projection_mentions_input_lifetimes(pred, *spans.first().unwrap(), supertrait_span)` in the elaborated-supertrait projection loop. This re-expresses fix hunk `@@ -174,6 +174,8 @@` which added that call after `projection_bounds.push((pred, span));`.
Added `#[allow(dead_code)]` on the now-unused function (from hunk `@@ -360,54 ...`) so the build stays warning-free.
