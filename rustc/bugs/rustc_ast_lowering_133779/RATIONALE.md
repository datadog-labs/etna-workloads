# Adapted injection for Use correct `hir_id` for array const arg infers

Fix: https://github.com/rust-lang/rust/commit/2807ba77a0b8c22d1326a6bfef87b28942fe9ab7

compiler/rustc_ast_lowering/src/lib.rs, lower_array_length_to_const_arg: the `ExprKind::Underscore` arm
allocates the ConstArg with `hir_id: self.next_id()` instead of `self.lower_node_id(c.id)`.
Re-expresses fix hunk `@@ -2013,7 +2013,8 @@` (`hir_id: self.next_id()` -> `self.lower_node_id(c.id)`).
The DefId created for the `_` anon const then has no matching HIR node (ICE when encoding metadata for a lib crate).
The encoder hunk is not re-expressed (the 1.99.1 code skips all ConstArg nodes).
