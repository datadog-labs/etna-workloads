# Adapted injection for Use FnOnceOutput instead of FnOnce where expected

Fix: https://github.com/rust-lang/rust/commit/d6b99b9c920f3c12326b0e7110236e9fe7c7ba52

# Rationale
File: compiler/rustc_middle/src/ty/print/pretty.rs, fn `insert_trait_and_projection` (fallback `traits.entry(trait_pred).or_default().extend(proj_ty)`), plus `DUMMY_SP` import.

The fix hunk (`@@ -1013,7 +1013,7 @@ pub trait PrettyPrinter`) changed
`(tcx.require_lang_item(LangItem::FnOnce, None), ty)` -> `(tcx.require_lang_item(LangItem::FnOnceOutput, None), ty)`:
the `FnOnce` trait DefId was used where an associated item (Output) DefId was expected.
That code was restructured in 1.99.1; the equivalent grouping of an Fn-family `Output` projection with the trait now lives in the fallback of `insert_trait_and_projection`. I re-introduced the typo: an Fn-family `Output` projection gets keyed by the `FnOnce` lang item (trait) instead of its assoc item id, so later `tcx.associated_item(..)` printing ICEs.
