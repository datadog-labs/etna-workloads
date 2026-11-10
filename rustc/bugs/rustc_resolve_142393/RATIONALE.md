# Adapted injection for Don't give APITs names with macro expansion placeholder fragments in it

Fix: https://github.com/rust-lang/rust/commit/8cd3fa04e2e023967cf2cfe3e4170b636fd25019

# Rationale
Only hunk changed: compiler/rustc_resolve/src/def_collector.rs, `DefCollector::visit_ty`, `TyKind::ImplTrait` arm.
Re-expresses fix hunk `@@ -380,20 +380,20 @@ ... fn visit_ty`: instead of reading the pre-expansion name from `resolver.impl_trait_names` (recorded in expand.rs before placeholders are inserted), the name is again computed at def-collection time with `pprust::ty_to_string(ty).replace('\n', " ")`, so APIT names can contain macro-expansion placeholder fragments. The other fix hunks (insert_impl_trait_name plumbing) are left in place but now unused for naming.
