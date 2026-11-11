# Adapted injection for ignore uncaptured lifetimes when checking opaques

Fix: https://github.com/rust-lang/rust/commit/4e1999d3870c7be9a4addcfcf4fd5db9d29b7d1c

# Rationale
Only file changed: compiler/rustc_type_ir/src/opaque_ty.rs (the 1.99.1 home of `OpaqueTypeKey::iter_captured_args` / `fold_captured_lifetime_args`, which the fix added in rustc_middle/src/ty/mod.rs: `@@ -832,6 +832,38 @@ pub struct OpaqueTypeKey<'tcx>`).

- `iter_captured_args`: the bivariant-lifetime arm `(Lifetime(_), Bivariant) => None` (fix: "ignore uncaptured lifetimes") now returns `Some((i, arg))`, so uncaptured lifetimes are validated/treated as captured again, as in the pre-fix `check_opaque_type_parameter_valid` hunk (`for (i, arg) in opaque_type_key.iter_captured_args(tcx)` replacing iterating all args of the parent generics).
- `fold_captured_lifetime_args`: removed the `(Lifetime(_), Bivariant) => arg` arm so uncaptured lifetimes are also mapped through `f`, mirroring the pre-fix `tcx.fold_regions(args, ...)` in the `@@ -179,7 +179,7 @@` borrowck hunk, which remapped every region.
