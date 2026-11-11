# Adapted injection for Suggest correct signature on missing fn returning RPITIT/AFIT

Fix: https://github.com/rust-lang/rust/commit/dbee24d94992df4c1888ebc2095d251fac22c05f

# Rationale
File: compiler/rustc_hir_analysis/src/check/mod.rs, fn `fn_sig_suggestion`.
Removed the async handling (`let mut output = sig.output();` + `let asyncness = if tcx.asyncness(assoc.def_id).is_async() { output = <extract Future::Output>; "async " } else { "" };`) and dropped `{asyncness}` from the format string. This re-expresses both hunks of fix.diff (`@@ -403,7 +403,32 @@ fn fn_sig_suggestion` and `@@ -414,7 +439,9 @@`), restoring parent behaviour: `let output = sig.output();` and `fn` signature without `async`, so missing `async fn` trait items get suggested as `fn foo() -> impl Future<..>` signatures.
