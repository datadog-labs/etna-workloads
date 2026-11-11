# Adapted injection for Don't expose type parameters and implementation details from macro expansion

Fix: https://github.com/rust-lang/rust/commit/b58347a9c607e493ff947ff470492c38f7819c72

All changes in compiler/rustc_trait_selection/src/error_reporting/infer/need_type_info.rs (file moved from rustc_infer in 1.99.1).
1. fn ident-data for type var (`var_origin = infcx.type_var_origin(ty_vid)`): removed `&& !var_origin.span.from_expansion()`. Re-expresses fix hunk `@@ -158,8 +158,12 @@ fn fmt_printer` (added `&& !var_origin.span.from_expansion()`).
2. Same removal in the TermKind::Ty branch of the infer-diagnostics-data fn. Re-expresses `@@ -254,7 +258,7 @@` (`if name != kw::SelfUpper && !var_origin.span.from_expansion()`).
3. `source_cost`: restored `let base_cost = match ...; let suggestion_may_apply = if source.from_expansion() { 10000 } else { 0 }; base_cost + suggestion_may_apply`. Re-expresses `@@ -797,17 +801,17 @@` (removed those lines).
4. `update_infer_source`: removed early `if new_source.from_expansion() { return; }`. Re-expresses same hunk (added that early return).
