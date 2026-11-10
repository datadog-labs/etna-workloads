# Bug
Snapshot keys (test names) were escaped with `templateEscape` (backslash, backtick, `${` only). Control characters such as `\r` and lone surrogates were written raw into the generated snapshot file's template literal, so they were not valid/round-trippable keys (issue 56836): the snapshot file read back doesn't match the key.

# Change (lib/internal/test_runner/snapshot.js)
1. `SnapshotFile.setSnapshot` uses `templateEscape(id)` instead of `escapeSnapshotKey(id)` (fix hunk 1, reversed).
2. Removed the `escapeSnapshotKey` function (JSON-stringify based escaping) added by the fix (fix hunk 2, reversed). `StringPrototypeSlice` import is now unused (harmless).

# Failing tests
`parallel/test-runner-snapshot-tests` fails ("not ok"; stable over repeated runs): the `\r 1` key assertion in SnapshotManager and the 'special characters are allowed' subtest (child exit code `actual: 1, expected: 0`).
