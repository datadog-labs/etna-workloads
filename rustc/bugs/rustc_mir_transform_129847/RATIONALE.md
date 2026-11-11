# Adapted injection for Do not call query to compute coroutine layout for synthetic body of async closure

Fix: https://github.com/rust-lang/rust/commit/384aed834cd83bdd0e93a2ef5690d3e44bf15856

# Rationale
compiler/rustc_mir_transform/src/validate.rs, `TypeChecker::visit_projection_elem`, `ty::Coroutine` arm:
removed the `else if self.tcx.needs_coroutine_by_move_body_def_id(def_id) && ... FnOnce && caller_body.source.def_id() == coroutine_by_move_body_def_id(def_id)` branch (which used `self.caller_body.coroutine_layout_raw()`). Re-expresses fix hunk `@@ -714,7 +715,17 @@` which added that "Same if this is the by-move body of a coroutine-closure" branch. Without it, the synthetic by-move body calls the `coroutine_layout` query -> cycle.
