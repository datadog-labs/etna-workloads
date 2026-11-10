# Adapted injection for Fix rustc_hidden_type_of_opaques for RPITITs with no default body

Fix: https://github.com/rust-lang/rust/commit/009feeb83e8e1c9637467e87207e9322cca307d4

compiler/rustc_hir_analysis/src/collect/dump.rs, fn opaque_hidden_types: removed the `if let OpaqueTyOrigin::FnReturn/AsyncFn {parent} ... && TraitItem ... TraitFn::Required(..) { continue; }` block, re-expressing reverse of fix hunk `@@ -11,6 +11,15 @@ pub(crate) fn opaque_hidden_types`. RPITIT opaques of required trait methods are dumped again (type_of on them is wrong/ICEs/extra error).
