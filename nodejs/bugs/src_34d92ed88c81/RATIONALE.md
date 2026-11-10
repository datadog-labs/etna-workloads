# CVE-2023-30587: inspector not restricted under the permission model

**Bug.** With `--permission` enabled, the inspector was not restricted: the Environment never marked the
inspector as denied, so `inspector.Session().connect()` succeeded and a sandboxed script could attach to its own
process (escaping fs/child-process restrictions via the inspector protocol).

**Change (src/env.cc, one hunk).** Removed the `if (!options_->allow_inspector) { flags_ |= kNoCreateInspector;
permission()->Apply(..., kInspector); }` block. This corresponds to the fix's env.cc hunk, which added
`kNoCreateInspector` and `permission()->Apply("*", kInspector)`. Without it the Inspector scope is never denied, so
the `THROW_IF_INSUFFICIENT_PERMISSIONS` checks in inspector_agent.cc (still present in the release) always pass
and the inspector is created. The other fix hunks (inspector_agent.cc checks, InspectorPermission class,
worker.cc guard) exist in the release and were left intact, since disabling the Apply is the minimal way to
restore the pre-fix behaviour.

**Failing test.** `parallel/test-permission-inspector`: `AssertionError [ERR_ASSERTION]: Missing expected exception.`
(session.connect() no longer throws ERR_ACCESS_DENIED).
