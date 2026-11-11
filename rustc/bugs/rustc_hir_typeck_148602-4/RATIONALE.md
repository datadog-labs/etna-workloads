# Adapted injection for non-behaviour changing cleanups

Fix: https://github.com/rust-lang/rust/commit/6f632ef2430f34523a19b90f574e288646225e9b

# Rationale
The upstream fix is almost entirely renames and cleanups; the only behaviour it documents is the one in the hunk
`@@ -475,11 +413,15 @@` of `coerce_borrowed_pointer` (now `coerce_to_ref`). It adds the note
"this can actually effect capture analysis ... FIXME(BoxyUwU): we should always emit reborrow coercions" to the
no-op skip `if coerced_a == a && mt_a.mutbl.is_not() && autoderef.step_count() == 1`.

Change (compiler/rustc_hir_typeck/src/coercion.rs, `Coerce::coerce_to_ref`): that skip is now taken only when
`self.use_lub`. For ordinary (non-LUB) coercions, `&'a T -> &T` always emits a reborrow adjustment.
This is the opposite of the structural-identity dependence the test checks: `bar` in
structural_identity_dependent_reborrows.rs should have no reborrow of `b`, so the closure captures `&&'a ()` and
borrowck reports E0373. With the change it reborrows, the closure captures `*b`, and the expected error disappears.
The cleanup hunks (renames, instrument `ret`, ty-var obligation refactor) are behaviour-neutral and were not re-injected.
