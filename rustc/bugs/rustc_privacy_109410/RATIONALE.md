# Adapted injection for IAT: Introduce AliasKind::Inherent

Fix: https://github.com/rust-lang/rust/commit/e8139dfd5a747842a8303f33d8c842378913d594

# Rationale

Only one file changed: `compiler/rustc_privacy/src/lib.rs`, in `DefIdVisitorSkeleton::visit_ty`.

Fix hunk re-expressed (`@@ -243,6 +243,39 @@ where` in compiler/rustc_privacy/src/lib.rs):
```
+            ty::Alias(ty::Inherent, data) => {
+                ...
+                self.def_id_visitor.visit_def_id(data.def_id, "associated type", &LazyDefPathStr {..})?;
```
The fix added a dedicated `ty::Alias(ty::Inherent, ..)` arm to the privacy visitor. It calls `visit_def_id` on the
associated type, so private-in-public checks see inherent associated types. In 1.99.1 the arm was merged into the
shared `Inherent | Free | Projection` arm. I removed `Inherent` from that shared arm, along with its `"associated type"`
label. I added a separate Inherent arm that skips `visit_def_id` and only visits the args, which is the pre-fix behaviour.
Result: the visibility of an inherent associated type is never checked, so private-in-public no longer reports it.
