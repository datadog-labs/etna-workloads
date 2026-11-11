# Adapted injection for Suppress

Fix: https://github.com/rust-lang/rust/commit/00b8189a187f353752039b72c10edd0ce2e038f9

# Rationale
Only file changed: compiler/rustc_trait_selection/src/error_reporting/infer/nice_region_error/named_anon_conflict.rs (try_report_named_anon_conflict).
1.99.1 already had the fix's structure (orig_param_ty, link_nomicon, Option<Span>). I removed the computation re-expressing fix hunk `@@ -72,7 +73,18 @@` (the `let orig_ty ...; suggestion_would_alias_lifetime = if let ty::Ref(_, orig_inner_ty, Mut) ... any_free_region_meets(...)`), replacing it with `false` (and dropped the now-unused `use rustc_middle::ty;`, hunk `@@ -2,6 +2,7 @@`). Result: E0621 again suggests `&'a mut Buffer<'a>` and omits the nomicon help.
