# Re-introduced bug: sqlite ignores ArrayBuffer / SharedArrayBuffer parameters

Bug: node:sqlite only accepted ArrayBufferView (TypedArray/DataView) as BLOB values. A bare ArrayBuffer or
SharedArrayBuffer was treated as a plain object (named-parameter bag) or rejected as unbindable.

Hunks (all in src/node_sqlite.cc, each matching one fix hunk):
1. JSValueToSQLiteResult (user-defined function results): condition reverted to `value->IsArrayBufferView()`.
2. StatementSync::BindParams: the "first arg is a named-parameter object" check reverted to
   `args[0]->IsObject() && !args[0]->IsArrayBufferView()`, so an ArrayBuffer is treated as a named-params object.
3. StatementSync::BindValue: blob branch reverted to `value->IsArrayBufferView()`, so ArrayBuffers are not bound.

Failing test: parallel/test-sqlite-typed-array-and-data-view (ArrayBuffer / SharedArrayBuffer suites), e.g.
`TypeError [ERR_INVALID_ARG_TYPE]: Provided value cannot be bound to SQLite parameter 1.` and
`AssertionError: The expression evaluated to a falsy value`. Stable across two runs.
