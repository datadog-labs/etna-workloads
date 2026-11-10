# Re-introduced bug: abort when two Environments share an IsolateData

**Bug.** The tcp_wrap binding initializer built its per-isolate FunctionTemplate on every
Environment and stored it with `env->set_tcp_constructor_template()`, which CHECKs that the
isolate-level slot is empty. A second Environment on the same `IsolateData` that loads
`tcp_wrap` (e.g. `require('net')`) therefore aborts.

**Change (src/tcp_wrap.cc only).** This corresponds to the fix's tcp_wrap.cc hunk, reversed.
- Always create the template instead of reusing `env->tcp_constructor_template()` when it
  is already set. Reverses the `if (t.IsEmpty())` guard.
- Drop `t->SetClassName("TCP")` and `SetConstructorFunctionFlag::NONE`. The default flag
  sets the class name when the constructor is exposed, as before the fix.
- Call `env->set_tcp_constructor_template(t)` unconditionally after `SetConstructorFunction`.
  This is the original order, and it hits the CHECK on the second Environment.

Only the tcp_wrap hunk was reverted. The other fix hunks are left in place, so the
change stays small. The bug is the same class and fails the same test.

**Failing test.** `EnvironmentTest.SharedIsolateDataLoadsBindingsTwice` aborts:
```
Node.js[9]: void node::Environment::set_tcp_constructor_template(...) at ../src/env-inl.h:945
Assertion failed: isolate_data()->tcp_constructor_template().IsEmpty()
```
It aborted on each of three runs. Other tests I ran (`MultipleEnvironmentsPerIsolate`) still pass.
I did not run the full oracle list or `tools/test.py`.
