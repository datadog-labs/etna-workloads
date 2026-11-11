# Adapted injection for const validation: properly ignore zero-sized UnsafeCell

Fix: https://github.com/rust-lang/rust/commit/3790eff4d40288de2e467dab02608815102ada7f

File: compiler/rustc_const_eval/src/interpret/validity.rs
- `visit_union`: fix hunk `@@ -1086,8 +1086,13 @@` (dynamic `zst` via size_and_align_of) restored to the old `!val.layout.is_zst() && !is_freeze(...)`.
- `visit_value`: fix hunk `@@ -1131,7 +1136,13 @@` restored to `if !val.layout.is_zst() && let Some(def) = ... is_unsafe_cell()`.
Unsized ZSTs (`UnsafeCell<[i32]>`, `UnsafeCell<dyn Trait>`) are then wrongly rejected in consts.
