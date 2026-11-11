# Adapted injection for fix: Overlapping spans in delimited meta-vars

Fix: https://github.com/rust-lang/rust/commit/770013d315e9a905e92794876b604568d2fb568e

# Rationale
File: compiler/rustc_expand/src/mbe/transcribe.rs, fn `maybe_use_metavar_location`.
The fix (hunk `@@ -236,6 +236,13 @@ fn expand_macro`) added a `(Delimited, MetaVar)` arm so that a delimited `tt`
substituted for a metavar gets `open = source_sp` and `close = source_sp.shrink_to_hi()`, i.e. non-overlapping
delimiter spans. In 1.99.1 that code moved: delimited tts get the metavar location only on the
collision fallback path, with open and close both equal to the full `$var` span (overlapping).
The change: the early `return orig_tt.clone()` is no longer taken for `TokenTree::Delimited`, so the
delimiters always get the overlapping metavar spans (the pre-fix behaviour).
