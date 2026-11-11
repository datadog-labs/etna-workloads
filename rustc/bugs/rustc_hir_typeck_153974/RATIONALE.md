# Adapted injection for Point at return type when it is the source of the type expectation

Fix: https://github.com/rust-lang/rust/commit/ca2139d3262232d6b15471783f503ffe125531f6

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, function reporting argument errors (`label_fn_like`), right after `err.span_note(spans, "... defined here")`.

- Hunk `@@ -1587,6 +1587,45 @@`: the fix added the `if let DefKind::Fn | DefKind::AssocFn ... ty::Param(_) = output ... { err.span_label(output.span(), "this ... return type influences the call expression's return type") }` block. Removed it entirely (restores the parent behaviour: no label on the return type).
- Hunk `@@ -11,7 +11,7 @@`: dropped `FnRetTy` from the `rustc_hir` import since it is now unused.
