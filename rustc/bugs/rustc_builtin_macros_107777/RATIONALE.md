# Adapted injection for Add ~const bounds trait bounds when using derive_const

Fix: https://github.com/rust-lang/rust/commit/7a4505900db08696071655018e72bad896fb9cb0

# Rationale
File: compiler/rustc_builtin_macros/src/deriving/generic/mod.rs, `TraitDef::create_derived_impl` (all 6 `cx.trait_bound(..., self.is_const)` calls: additional_bounds, current trait, Copy bound, in both the type-param bounds and where-clause paths).
Fix hunks `@@ -605,18 +605,26 @@` and `@@ -694,18 +702,24 @@` passed `self.is_const` so derive_const adds `~const` bounds. Re-injected bug: pass `false`, so generic params get plain `T: PartialEq` bounds and the const impl fails for `Reverse<i32>` comparison in const fn.
The other fix hunks (build.rs signature, debug.rs, ty.rs) are already equivalent/not needed.
