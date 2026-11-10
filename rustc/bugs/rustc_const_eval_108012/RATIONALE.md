# Adapted injection for Don't ICE in might_permit_raw_init if reference is polymorphic

Fix: https://github.com/rust-lang/rust/commit/087a0136d01d0ee05d4e8c5e91f2e01978244a67

Hunk: compiler/rustc_const_eval/src/util/check_validity_requirement.rs, check_validity_requirement_lax (formerly might_permit_raw_init_lax).
Re-expresses fix hunk `@@ -108,7 +108,12 @@ fn might_permit_raw_init_lax`: the fix replaced `cx.layout_of(pointee.ty).expect("need to be able to compute layouts")` with a graceful fallback for polymorphic pointees. In 1.99.1 the graceful form is `cx.layout_of(pointee)?`; I restored `.expect("need to be able to compute layouts")`, so a polymorphic pointee (&T) ICEs.
(The TypeVisitable import hunk is not needed.)
