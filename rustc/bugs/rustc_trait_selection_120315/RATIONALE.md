# Adapted injection for Account for expected `dyn Trait` found `impl Trait`

Fix: https://github.com/rust-lang/rust/commit/796814d91627203444769a680c53ff59a7ff4696

Hunk: compiler/rustc_trait_selection/src/error_reporting/infer/note_and_explain.rs, function note_type_err (match on (expected, found) kinds).
Removed the arm `(ty::Dynamic(t, _), ty::Alias(_, Opaque{..})) if principal trait is among opaque's item bounds` that emits
"you can box the `impl Trait` to coerce it to `Box<dyn Trait>`, but you'll have to change the expected type as well".
Re-expresses fix hunk `@@ -294,6 +294,26 @@ impl<T> Trait<T> for X {` in rustc_infer/.../note_and_explain.rs (the added `(ty::Dynamic(t, _, ty::DynKind::Dyn), ty::Alias(ty::Opaque, alias))` arm). The file moved to rustc_trait_selection in 1.99.1.
