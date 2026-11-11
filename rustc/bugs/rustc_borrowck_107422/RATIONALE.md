# Adapted injection for Also erase substs for new infcx in pin move error

Fix: https://github.com/rust-lang/rust/commit/832751fe1df232e36b283fa136b4e26475e55c00

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/mod.rs, fn report_use_of_moved_or_uninitialized (Pin `FreshReborrow` suggestion block).

Fix hunk `@@ -1128,8 +1128,12 @@` added `let method_substs = tcx.erase_regions(method_substs);` ("Erase and shadow everything that could be passed to the new infcx") next to `let infcx = tcx.infer_ctxt().build();`.
In 1.99.1 the code no longer builds a new infcx; it used `self.infcx`, so the erase was moot. To re-express the bug: the Pin check now builds a fresh infcx (with the erased `ty`, as in the original) and calls `tcx.fn_sig(method_did).instantiate(tcx, method_args)` with the *unerased* `method_args` and passes it to that fresh infcx (`instantiate_binder_with_fresh_vars`, `can_eq`). Unerased args containing inference vars from the outer infcx ICE the new one, as in #107419.
