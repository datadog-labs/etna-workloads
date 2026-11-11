# Adapted injection for Avoid extra path trimming in method not found error

Fix: https://github.com/rust-lang/rust/commit/01503d0c1e43a23de92ad1577cbdceb7afe47dab

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn report_no_match_method_error's helper that emits the "{item_kind} not found in `{ty_str}`" label (the one using `short_string(rcvr_ty, ...)`).
Re-expresses fix hunk `@@ -738,10 +738,6 @@` which removed
`if short_ty_str.len() < ty_str.len() && ty_str.len() > 10 { ty_str = short_ty_str; }`.
In 1.99.1 the code was restructured, so I re-added the forced trim (`with_forced_trimmed_paths!(rcvr_ty.to_string())`) with the same condition right after computing `ty_str`; `ty_str` made `mut` (cf. hunk 1 `let (mut ty_str, ...)`).
