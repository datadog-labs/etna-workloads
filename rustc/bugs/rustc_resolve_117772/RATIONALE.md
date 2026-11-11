# Adapted injection for By tracking import use types to check whether it is scope uses or the other situations like module-relative uses, we can do more accurate redundant import checking.

Fix: https://github.com/rust-lang/rust/commit/a61126cef6c4083d57e22835033eb2eefdd31bac

# Re-injected bug
File: compiler/rustc_resolve/src/imports.rs, fn `check_for_redundant_imports`.

Fix hunk `@@ -1323,16 +1325,20 @@` replaced
`if let ModuleKind::Def(..) = import.parent_scope.module.kind {` (skip every import inside a named module)
with `if import.used.get() == Some(Used::Other) || self.effective_visibilities.is_exported(...)` (use-type-based skip).
In 1.99.1 the equivalent is `import_use_map.get(&import) == Some(&Used::Other) || is_exported(def_id)`.
I restored the old check: `if let crate::ModuleKind::Def(..) = import.parent_scope.module.kind { return false; }`,
so redundant imports inside named modules (e.g. `use std::option::Option::Some;` in a mod/crate root) are no longer linted.
I also dropped the now-unused `def_id` binding.
