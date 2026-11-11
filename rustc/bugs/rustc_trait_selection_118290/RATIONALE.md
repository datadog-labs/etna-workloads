# Adapted injection for Don't ICE when encountering placeholders in implied bounds computation

Fix: https://github.com/rust-lang/rust/commit/1279f70bf43c7f807abdedf818ca9680f0e9676f

# Rationale
File: compiler/rustc_trait_selection/src/traits/implied_outlives_bounds.rs (moved from traits/query/type_op/implied_outlives_bounds.rs), fn implied_bounds_from_components.
Restored the `Component::Placeholder(_) => unimplemented!("Shouldn't expect a placeholder type in implied bounds (yet)")` arm, replacing the `None` arm.
Re-expresses fix hunk `@@ -207,8 +207,10 @@ fn implied_bounds_from_components`: `-Component::Placeholder(_) => { unimplemented!(...) }` / `+Component::Placeholder(_p) => { ... None }`.
