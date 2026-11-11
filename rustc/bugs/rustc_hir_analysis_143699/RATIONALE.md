# Adapted injection for Make AsyncDrop check that it's being implemented on a local ADT

Fix: https://github.com/rust-lang/rust/commit/728017ea8f14e0cc343a6ded0e955868d628cc76

# Rationale
File: compiler/rustc_hir_analysis/src/coherence/builtin.rs, `check_trait`.
Removed the arm `Some(LangItem::AsyncDrop) => visit_implementation_of_drop(&checker),`.
Re-expresses fix hunk `@@ -37,6 +37,7 @@ pub(super) fn check_trait` which added
`checker.check(lang_items.async_drop_trait(), visit_implementation_of_drop)?;`.
Without it, AsyncDrop impls on non-local/foreign-fundamental ADTs (`&Foo`, `Pin<Foo>`) are not rejected with E0120.
The other fix hunks (message text / `trait_` field) are only diagnostics wording for that arm and are left as is.
