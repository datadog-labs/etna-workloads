# Adapted injection for fix(resolve): only disambiguate binding key during define

Fix: https://github.com/rust-lang/rust/commit/5b098109765f4198bdff016a856610f3425a2167

# Re-injection rationale
The fix split `new_key` into `BindingKey::new` (plain lookup key, used everywhere except define) and `new_disambiguated_key` (define only). Buggy parent: every `new_key` call site bumped the underscore disambiguator. In 1.99.1 the equivalent is `BindingKey::new` vs `BindingKey::new_disambiguated(.., || counter bump)`.

1. ident.rs, `resolve_ident_in_module_non_globs_unadjusted` / `resolve_ident_in_module_globs_unadjusted` (two lookups):
   re-expresses `@@ -865,7 +866,7 @@ ... -let key = self.new_key(ident, ns); +let key = BindingKey::new(ident, ns);`
   (and the `late.rs`/`diagnostics.rs` lookup hunks). Lookup now uses `new_disambiguated`, bumping `module.underscore_disambiguator` for `_` idents during lookup. This panics in the speculative (non-mutable) CmCell context.
2. imports.rs, `import_dummy_binding` and the `PendingDecl::Ready(None)` arm of import finalization:
   re-expresses `@@ -415 / -712: -let key = this.new_key(target, ns); +let key = BindingKey::new(target, ns);` — removal of single_imports now uses disambiguated key, with the later-added `!= kw::Underscore` guard dropped.
