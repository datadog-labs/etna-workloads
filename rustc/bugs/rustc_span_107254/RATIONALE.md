# Adapted injection for Fix #107113, avoid suggest for macro attributes

Fix: https://github.com/rust-lang/rust/commit/75b9f53e47d8a9765bbd54372b94040debcf1eef

# Hunk: compiler/rustc_span/src/hygiene.rs, `SyntaxContext::in_external_macro`
The fix's second hunk (`@@ -449,7 +449,11 @@ pub fn in_external_macro` in rustc_middle/src/lint.rs) added
`DesugaringKind::Async | DesugaringKind::Await` to the kinds treated as not-external. In 1.99.1 this function lives in
rustc_span hygiene.rs; I removed `Async` and `Await` from that list again, so async/await desugaring spans count as external macros
and suggestions (e.g. "consider unboxing") are suppressed (the old buggy behaviour).
The demand.rs hunk (early `return false` on in_external_macro) was not re-expressed; the 1.99.1 code already guards differently.
