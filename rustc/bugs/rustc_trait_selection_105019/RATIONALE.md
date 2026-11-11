# Adapted injection for fix #104961, Add parentheses properly for borrowing suggestion

Fix: https://github.com/rust-lang/rust/commit/8f736a40426bf0182b92637e9c221da12745a180

File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, closure `try_borrowing` in suggest_borrowing_for_trait_bound path.
Change: `let needs_parens_post = false && expr_needs_parens(expr);` so compound exprs (Binary/Cast/range) get `&expr` without parentheses.
Re-expresses fix hunk `@@ -1350,14 +1351,41 @@` which added `needs_parens` (Cast | Binary | range literal => true) and the multipart suggestion `&(` ... `)`; the pre-fix code always suggested a plain `&` prefix at span.shrink_to_lo().
