# Adapted injection for fix implied bound computation for nested bodies

Fix: https://github.com/rust-lang/rust/commit/c34440acd991e245f8ca87af560f4914c82b192b

# Rationale
One hunk: compiler/rustc_borrowck/src/implied_bounds.rs, `mir_borrowck_implied_outlives_bounds`.
Re-expresses fix hunk `@@ -27,8 +31,20 @@ mir_borrowck_implied_outlives_bounds`: the fix chose
`TypingEnv::post_typeck_until_borrowck` for `tcx.is_typeck_child(..)` bodies; I restored the old
unconditional `TypingEnv::non_body_analysis(tcx, body_def_id)`, so nested bodies can't define opaques
when computing implied bounds. (The other fix hunks were already present in 1.99.1 and left intact.)
