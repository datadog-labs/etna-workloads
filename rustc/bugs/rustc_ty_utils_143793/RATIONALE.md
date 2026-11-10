# Adapted injection for Opaque type collection: Guard against endlessly recursing free alias types

Fix: https://github.com/rust-lang/rust/commit/28af50075724bd1fa94b7e147b1e230534a70ab9

compiler/rustc_ty_utils/src/opaque_types.rs, OpaqueTypeCollector::visit_ty, `ty::Alias(_, Free{def_id})` arm:
removed the `if !self.seen.insert(def_id) { return; }` guard. Re-expresses fix hunk
`@@ -223,7 +223,10 @@ impl TypeVisitor for OpaqueTypeCollector` which added that guard against endlessly recursing free aliases.
(The second hunk, a rename impl_args->alias_args, is behaviour-neutral.)
