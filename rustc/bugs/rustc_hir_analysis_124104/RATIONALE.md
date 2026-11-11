# Adapted injection for Fix capturing duplicated lifetimes via parent

Fix: https://github.com/rust-lang/rust/commit/5daf58ffc1d46a63d33652cc953a3a801b8d1265

Single file: compiler/rustc_hir_analysis/src/check/check.rs, fn check_opaque_precise_captures.
Removed the `shadowed_captures` set (fix hunk `@@ -492,6 +492,7 @@ ... let mut shadowed_captures = UnordSet::default();`),
its population from `map_opaque_lifetime_to_parent_lifetime` (hunk `@@ -530,6 +531,21 @@`), and the
`if shadowed_captures.contains(&param.def_id) { continue; }` skip (hunk `@@ -555,23 +571,30 @@`).
So capturing the parent copy of a lifetime (via `Self`) wrongly errors. The param_span hunk was not reversed (cosmetic/diagnostic).
