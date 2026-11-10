# Re-introduced bug: CVE-2026-56847 (trace events bypass fs write permission)

**Bug:** `trace_events.createTracing(...).enable()` starts the tracing agent, which opens `node_trace.N.log` in the cwd, without checking `--allow-fs-write`. Under `--permission` a script can therefore create files outside the allowed write paths.

**Change (src/node_trace_events.cc, `NodeCategorySet::Enable`):** removed the `THROW_IF_INSUFFICIENT_PERMISSIONS(..., kFileSystemWrite, tracing::GetTraceFilePath(...))` call. This corresponds to the fix's hunk adding that check in the same function. In this release the helper is called `GetTraceFilePath` instead of `NodeTraceWriter::GetFilePath`, and it is already used by the writer, so I left the node_trace_writer.* hunks alone. They only refactor the path helper and are harmless without the check.

**Failing test:** parallel/test-permission-fs-write-trace-events. The child process run with `--permission` exits with status 1 because `tracing.enable()` no longer throws `ERR_ACCESS_DENIED`. The parent then reports "process terminated with status 1, expected 0". The failure was the same on repeated runs.
