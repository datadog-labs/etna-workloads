# Adapted injection for Pass the right HIR back from get_fn_decl

Fix: https://github.com/rust-lang/rust/commit/08c913279fc21e57acd210a98dfdfd740e86b565

# Hunk: compiler/rustc_hir_typeck/src/fn_ctxt/_impl.rs, `FnCtxt::get_fn_decl`
In the async-fn desugared coroutine closure arm, 1.99.1 returns `(owner_id.def_id, sig.decl)` (the parent fn's id, with the parent's decl). I changed it to return the closure's `def_id` while keeping the parent's `sig.decl`.
Re-expresses the fix's `_impl.rs` hunk `@@ -898,51 +898,74 @@` (get_node_fn_decl/get_fn_decl), which made it return `hir::HirId::make_owner(owner_id.def_id)` for the enclosing fn, even when called from the nested closure. Before the fix, the wrong id (the closure / `get_parent_item`, via `fn_id = get_return_block(blk_id)`) was passed to `suggest_missing_return_type`, which then looked up the wrong item. Result: ICE or wrong suggestion on `async fn ice(_: &i32) { true }` (late-bound vars).
