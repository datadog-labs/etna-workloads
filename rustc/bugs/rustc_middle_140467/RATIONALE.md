# Adapted injection for Don't FCW assoc consts in patterns

Fix: https://github.com/rust-lang/rust/commit/be906131de0079173048194c368ebefaa5e426d4

# Rationale
File: compiler/rustc_middle/src/mir/interpret/queries.rs, fn `const_eval_resolve_for_typeck` (the `.inspect(|_| ...)` closure).

Fix hunk `@@ -115,15 +115,16 @@`: replaced the condition so the CONST_EVALUATABLE_UNCHECKED FCW is only emitted for
`self.def_kind(instance.def_id()) == DefKind::AnonConst` (old code accepted InlineConst/AnonConst/AssocConst).
Re-injection: the `== DefKind::AnonConst` check is widened to `matches!(def_kind, AnonConst | AssocConst { .. })`
(InlineConst no longer exists as a DefKind in 1.99.1), so assoc consts in patterns get the FCW again.

Additional change: removed `&& !self.is_trivial_const(def_id)`. This guard did not exist upstream at the time of the fix; in 1.99.1
it independently suppresses the FCW for the test's const (its body is considered trivial), so it had to go for the bug to be observable.
Non-trivial polymorphic consts are unaffected; it only restores pre-guard behaviour (extra mir_for_ctfe call on trivial anon consts).
