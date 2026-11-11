# Adapted injection for Fix for async drop inside async gen fn

Fix: https://github.com/rust-lang/rust/commit/d5a9a005188322cd08dca018402e1593d3a5ebd5

# Hunk: compiler/rustc_mir_transform/src/elaborate_drop.rs, async-drop yield value construction
The fix hunk `@@ -382,12 +382,34 @@ expand_async_drops` in coroutine/drop.rs made the yielded value for AsyncGen
`yield Poll<OptRet>::Pending` (AsyncGenPending lang item) instead of `Const::from_bool(false)`.
In 1.99.1 this logic moved to elaborate_drop.rs (`yield_value` match). I replaced the AsyncGen arm
with the old `Const::from_bool(tcx, false)` constant, reintroducing the type mismatch (ICE #140530).
