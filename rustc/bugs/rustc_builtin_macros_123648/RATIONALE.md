# Adapted injection for Avoid ICEing without the `pattern_types` feature gate

Fix: https://github.com/rust-lang/rust/commit/24ee9b9423465ea4b1cc482e5aaf3a38758b2167

# Rationale
File: compiler/rustc_builtin_macros/src/pattern_type.rs, fn `pat_to_ty_pat`.
The fix hunk `@@ -2249,7 +2249,11 @@ ... hir_ty_lowering/mod.rs` replaced
`_ => span_bug!(pat.span, "unsupported pattern for pattern type: {pat:#?}")` with an error type (no ICE).
In 1.99.1 that fallback lives in the `pattern_type!` macro (`_ => TyPatKind::Err(span_err(... "pattern not supported in pattern types"))`).
I re-introduced the old behaviour: the fallback arm is now `cx.dcx().span_bug(pat.span, "unsupported pattern for pattern type: ...")`, so unsupported patterns ICE.
