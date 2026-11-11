# Adapted injection for collect attrs in const block expr

Fix: https://github.com/rust-lang/rust/commit/1e42bb606d9abcfa22ee248e3a8598f813632418

# Rationale
File: compiler/rustc_resolve/src/def_collector.rs, `DefCollector::visit_expr`.
Fix hunk (`@@ -343,6 +343,9 @@ ... ExprKind::ConstBlock(ref constant) =>`) added `for attr in &expr.attrs { visit::walk_attribute(self, attr); }` so attributes on a const block expr get collected (macro invocations in them are registered).
In 1.99.1 attrs are visited by generic `walk_expr`; I re-added a dedicated `ExprKind::ConstBlock(constant) => self.visit_anon_const(constant)` arm that skips the expr's attrs, restoring the bug (attr macro invocation `foo!()` never collected -> no resolution error / ICE).
