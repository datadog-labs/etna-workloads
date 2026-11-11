# Adapted injection for propagate `tainted_by_errors` in `MirBorrowckCtxt::emit_errors`

Fix: https://github.com/rust-lang/rust/commit/f7679d050793304eff9ff2a46a824cc5495e6f93

# Hunk: compiler/rustc_borrowck/src/lib.rs, function `do_mir_borrowck`
Removed the block
    if let Some(guar) = infcx.tainted_by_errors() { root_cx.set_tainted_by_errors(guar); }
In 1.99.1 `MirBorrowckCtxt::emit_errors` no longer exists; this is where the infcx taint is propagated into the borrowck result.
Re-expresses fix hunk `@@ -2522,7 +2522,7 @@ mod diags` in `emit_errors`: `let mut res = None;` -> `let mut res = self.infcx.tainted_by_errors();`
i.e. the fix propagated infcx `tainted_by_errors`; the bug is not propagating it.
