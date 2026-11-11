# Adapted injection for add checks for the signature of the  lang item

Fix: https://github.com/rust-lang/rust/commit/337a97d3741bb78319cde745119cf96941b78325

# Rationale
File: compiler/rustc_hir_typeck/src/check.rs, fn `check_fn` (end).
The fix added, in `check_fn`, the hunk
`+    if let Some(lang_start_defid) = tcx.lang_items().start_fn() && ... { check_lang_start_fn(tcx, fn_sig, decl, fn_def_id); }`
(hunk after `@@` in check.rs adding the call and `check_lang_start_fn`). In 1.99.1 this is
`if tcx.is_lang_item(.., LangItem::Start) { check_lang_start_fn(..) }`; I removed that call, restoring the
pre-fix behaviour (no signature check on the `start` lang item). `check_lang_start_fn` is kept with `#[allow(dead_code)]` to avoid an unused warning.
