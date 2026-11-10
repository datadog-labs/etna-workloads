# Adapted injection for Separate collection of crate-local inherent impls from error reporting

Fix: https://github.com/rust-lang/rust/commit/cfb8419900c1511b09320d70105128ce13de6e71

# Rationale
File: compiler/rustc_hir_analysis/src/coherence/inherent_impls.rs, functions `crate_incoherent_impls` and `inherent_impls`.

In 1.99.1 these providers read `tcx.crate_inherent_impls(()).0` and ignore the collection result `.1`. The fix hunk
`@@ -22,36 +22,38 @@ pub(crate) fn crate_inherent_impls(` changed them from
`let crate_map = tcx.crate_inherent_impls(())?;` (an error anywhere makes every inherent impl lookup fail) to
`let (crate_map, _) = tcx.crate_inherent_impls(());`.
I re-added the old behaviour by having both providers return `&[]` when the collection result is `Err`.
The old code returned `Err` there, and callers treated that as "no impls". The query signatures were left as they are,
because reversing them everywhere would be a large change. One invalid impl, such as `impl () {}`, again hides all other inherent impls.
