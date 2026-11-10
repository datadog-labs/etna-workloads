# Adapted injection for fix computing the dynamic alignment of packed structs with dyn trait tails

Fix: https://github.com/rust-lang/rust/commit/7e4c4271f44055b4dbd6f09aad19624254d67f22

# Rationale
1. compiler/rustc_codegen_ssa/src/size_of_val.rs, `size_and_align_of_dst`: re-expresses fix hunk `@@ -95,26 +98,26 @@` (the "For packed types, we need to cap the alignment" block with min(unsized_align, packed)). Reverted to old `if def.repr().packed() { unsized_align = sized_align; }`, so packed(N>1) dyn tails get the wrong dynamic alignment.
2. compiler/rustc_const_eval/src/interpret/eval_context.rs, `size_and_align_of_val`: re-expresses fix hunk `@@ -707,36 +701,35 @@` (`unsized_align = unsized_align.min(packed)`), reverted to `unsized_align = sized_align` when packed.
