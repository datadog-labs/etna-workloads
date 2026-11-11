# Adapted injection for Add label rib when visiting delegation body, add test

Fix: https://github.com/rust-lang/rust/commit/968376d507d86e935cc0f61da9c206fbf9633bdb

# late.rs, resolve_delegation
Removed the `this.with_label_rib(RibKind::FnOrCoroutine, |this| {...})` wrapper (and its #148889 comment) around the delegation body's `visit_block` (the lifetime rib stays). This re-expresses the fix hunk `@@ -3689,7 +3689,11 @@` which added `this.with_label_rib(RibKind::FnOrCoroutine, ...)` around `this.visit_block(body)`. Without it, labels from the enclosing function are visible in the body, so `break 'foo` is not rejected as unreachable.
