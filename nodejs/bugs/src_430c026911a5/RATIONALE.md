# Re-introduced bug: permission inspector crash (nodejs/node#53385)

With `--experimental-permission --inspect-brk`, the inspector is not allowed, but the code paths that
pause on the first statement did not check the kInspector permission, so the process crashed
(signal/abort, status null) instead of exiting 1 with ERR_ACCESS_DENIED.

## Hunks
1. `src/inspector_js_api.cc` `CallAndPauseOnStart`: removed the `THROW_IF_INSUFFICIENT_PERMISSIONS(... kInspector, "PauseOnNextJavascriptStatement")` (the fix added it).
2. `src/node_contextify.cc` `ContextifyScript::EvalMachine` (`break_on_first_line` block): removed the `is_granted` check / `ThrowAccessDenied` / rethrow block (the fix added it, now written with `[[unlikely]]`), leaving the unconditional `PauseOnNextJavascriptStatement("Break on start")`.

## Failing test
`parallel/test-permission-inspector-brk` fails (stable over repeated runs):
`AssertionError: Expected values to be strictly equal: null !== 1` at test line 28 (process crashed rather than exiting 1).
