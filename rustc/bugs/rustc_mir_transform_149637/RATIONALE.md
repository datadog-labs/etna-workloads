# Adapted injection for Do not run jump-threading for GPUs

Fix: https://github.com/rust-lang/rust/commit/12f17b9738eccce48ce940abf667ea74e1d94b04

# Hunk: compiler/rustc_mir_transform/src/jump_threading.rs, `JumpThreading::policy`
In 1.99.1 `is_enabled` became `policy()`. The fix hunk (`@@ -76,6 +84,14 @@ impl MirPass for JumpThreading`) added
`if sess.target.is_like_gpu { return false; }` before `sess.mir_opt_level() >= 2`.
I removed the `is_like_gpu` branch so `enabled_by_default = sess.mir_opt_level() >= 2` for all targets, so GPU targets run jump-threading again.
