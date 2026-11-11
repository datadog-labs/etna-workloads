# Adapted injection for Fix trimmed_def_paths ICE in the function ptr comparison lint

Fix: https://github.com/rust-lang/rust/commit/3f105be05cecfaa48e5a6f5ebb356f48cd0228db

Fix hunk `@@ -483,29 +483,36 @@ fn lint_fn_pointer` (types.rs, lint_fn_pointer): fix replaced eager `cast_right = format!(" as {fn_sig}")` with a lazy `fn_sig: PolyFnSig` field. Reinjected: types.rs eagerly formats `cast_right` String (formatting a user type outside diagnostic emission -> trimmed_def_paths ICE) and passes it to `FnAddrEqWithCast`.
Fix hunks `@@ -1816,14 ...` / `@@ -1833,22 ...` (lints.rs, now moved to rustc_lint/src/diagnostics.rs): fix added the `'tcx` lifetime and `fn_sig: PolyFnSig<'tcx>` with `code = " as {fn_sig})"`. Reinjected: removed `'tcx`, field is `cast_right: String` with `code = "{cast_right})"`.
