# Adapted injection for Resolve instance for SymFn in global/naked asm

Fix: https://github.com/rust-lang/rust/commit/3a1ee645cad501e2fd766bbacea5654a795f352b

# Rationale
Both hunks revert `Instance::expect_resolve(...)` back to an unresolved `Instance::new_raw(def_id, args.skip_binder())` (1.99.1's equivalent of the old `Instance::new`).

1. compiler/rustc_codegen_ssa/src/base.rs, global-asm operand lowering (`InlineAsmOperand::SymFn`): re-expresses fix hunk `@@ -457,7 +457,13 @@` (`-&ty::FnDef(def_id, args) => Instance::new(def_id, args)` / `+Instance::expect_resolve(... fully_monomorphized ...)`). Trait-assoc fns like `<i32 as Foo>::bar` are no longer resolved to the impl.
2. compiler/rustc_codegen_ssa/src/mir/naked_asm.rs, `inline_to_global_operand` (`SymFn`): re-expresses fix hunk `@@ -95,7 +95,9 @@` (same swap with `cx.typing_env()`).
