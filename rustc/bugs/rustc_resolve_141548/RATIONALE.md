# Adapted injection for consider glob imports in cfg suggestion

Fix: https://github.com/rust-lang/rust/commit/e9080948c64cdb12014f11004a921a676fbc0964

# Hunk: compiler/rustc_resolve/src/diagnostics/impls.rs (the code moved from diagnostics.rs), cfg-stripped-item suggestion function
Fix hunk `@@ -2623,7 +2623,53 @@ impl Resolver` replaced `if parent_module != module || ident.name != *segment { continue; }`
with a glob-aware `comes_from_same_module_for_glob` check. I removed the helper and the
`comes_from_same_module` check and restored the exact `parent_module != module || ident.name != *segment` test,
so items stripped by cfg and reached via glob re-exports are no longer suggested.
The expand.rs hunk is a pure refactor (no behaviour change) and was not re-injected.
