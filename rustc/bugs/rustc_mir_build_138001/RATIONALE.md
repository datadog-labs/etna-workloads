# Adapted injection for mir_build: consider privacy when checking for irrefutable patterns

Fix: https://github.com/rust-lang/rust/commit/044deec6824a834ac870e6d081807d432a999807

# Rationale
File: compiler/rustc_mir_build/src/builder/matches/match_pair.rs, `InterPat::lower_thir_pat`, `PatKind::Variant` arm.
Fix hunk `@@ -273,10 +273,11 @@` replaced `apply_ignore_module(...)` with `.apply(tcx, typing_env, cx.def_id.into())` in the `irrefutable` computation
(variants uninhabited only privately must not make the pattern irrefutable). In 1.99.1 the code was restructured and that
check was gone, so I re-added the pre-fix computation: a variant pattern is irrefutable if all other variants are uninhabited
ignoring module visibility (`apply_ignore_module`) and the enum is not non-exhaustive. This brings back the bug.
