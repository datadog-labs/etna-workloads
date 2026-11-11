# Adapted injection for mentioned items: also handle closure-to-fn-ptr coercions

Fix: https://github.com/rust-lang/rust/commit/f1ec494c322a2eabbba0bf93867170f702e7a05a

# Rationale
One hunk: compiler/rustc_mir_transform/src/mentioned_items.rs, `MentionedItemsVisitor::visit_rvalue`.
Removed the arm `Rvalue::Cast(PointerCoercion(ClosureFnPointer(_), _), ref operand, _)` that pushes `MentionedItem::Closure(source_ty)`.
This re-expresses fix hunk `@@ -74,6 +74,22 @@ impl<'tcx> Visitor<'tcx> for MentionedItemsVisitor` ("Similarly, record closures that are turned into function pointers"), which added that arm. The MentionedItem::Closure variant and collector handling remain (now unused), as in 1.99.1's different representation (Closure(Ty)), so the middle/collector hunks are not reversed; without the recording, closures in dead code are never collected, so the const error is missed.
