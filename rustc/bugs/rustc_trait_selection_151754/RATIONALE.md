# Adapted injection for Check proj's parent when checking dyn compatibility

Fix: https://github.com/rust-lang/rust/commit/829c314f2820a330d09b58c2e8c9a7d1b6991341

# Rationale
File: compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs, `IllegalSelfTypeVisitor::visit_const`.
Fix hunk `@@ -833,8 +834,10 @@ ... visit_const`: the fix added `&& self.tcx.def_kind(trait_def_id) == DefKind::Trait`
so that `tcx.parent(proj.def)` is only treated as a trait when it really is one (otherwise falls to `_ => ct.super_visit_with(self)`).
In 1.99.1 the equivalent guard is the `AliasConstKind::Projection { def_id }` pattern. Re-injection: match any `AliasConst` kind
(Free/Inherent/Anon too), take its def_id and unconditionally treat `tcx.parent(def_id)` as a trait, so a free `#[type_const] const N` in a trait method signature
makes `TraitRef::from_assoc` ICE on a module parent.
