# Adapted injection for Allow for try_force_from_dep_node to fail

Fix: https://github.com/rust-lang/rust/commit/db5ed4bd799cda1217ec6431ffa56cecd09ef6e9

# Hunk: compiler/rustc_middle/src/dep_graph/mod.rs, `try_force_from_dep_node`
(fix moved from rustc_query_system/src/dep_graph/mod.rs.)
Fix hunk `@@ -51,20 +51,24 @@ pub trait DepContext` changed `f(self, dep_node);` + trailing `true` into
`Ok(query_has_been_forced) => query_has_been_forced`. Re-injected the old behaviour: the
result of the force fn is ignored and `Ok(_) => true` is returned, so a failed forcing
(unrecoverable key) is treated as success.
