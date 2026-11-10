# Adapted injection for Merge impl_wf_inference into coherence checking

Fix: https://github.com/rust-lang/rust/commit/a947654a96651e3acc911fe202907b283cd2ed5b

# Hunk: compiler/rustc_hir_analysis/src/lib.rs, `check_crate`
Re-expresses fix hunk `@@ -181,14 +181,11 @@ pub fn check_crate`, which removed
`tcx.sess.track_errors(|| { tcx.sess.time("impl_wf_inference", ...check_mod_impl_wf...) })?;`
(a separate impl-WF pass acting as an error barrier before coherence) and merged it into coherence checking.
In 1.99.1 impl wf is in wfcheck and `check_mod_impl_wf` is gone, so I re-added a pre-coherence
"impl_wf_inference" pass that runs `enforce_impl_non_lifetime_params_are_constrained` on every local impl,
then `abort_if_errors()` (the track_errors barrier), so coherence errors are not reported when impls are unconstrained.
