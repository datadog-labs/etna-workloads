# Adapted injection for Use ObligationCtxt::new_in_snapshot in satisfied_from_param_env

Fix: https://github.com/rust-lang/rust/commit/343a359109a48f4ece657831bf0331e22d108800

# const_evaluatable.rs, satisfied_from_param_env
Fix hunk: `@@ -219,7 +219,7 @@ fn satisfied_from_param_env` : `-let ocx = ObligationCtxt::new(infcx);` / `+let ocx = ObligationCtxt::new_in_snapshot(infcx);`
In 1.99.1 `new_in_snapshot` no longer exists (ObligationCtxt::new tolerates snapshots, tracking depth), so the old
behaviour (ObligationCtxt::new requiring a non-snapshot infcx) is re-expressed as `assert!(!infcx.in_snapshot());`
before `ObligationCtxt::new(infcx)` in the `if let Some(Ok(c)) = single_match` block. Called from within a probe, this ICEs.
