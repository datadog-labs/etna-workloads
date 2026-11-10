# Rationale

Bug: lib/internal/v8/startup_snapshot.js destructured ERR_NOT_BUILDING_SNAPSHOT and
ERR_DUPLICATE_STARTUP_SNAPSHOT_MAIN_FUNCTION directly from `require('internal/errors')`
instead of from its `codes` property. They were therefore undefined, and `new ERR_...()`
threw "ERR_NOT_BUILDING_SNAPSHOT is not a constructor" instead of the intended error.

Hunk (single, lib/internal/v8/startup_snapshot.js): corresponds to the fix's only
implementation hunk. The two error names are moved out of `codes: {}` to top level of the
destructuring (ERR_NOT_SUPPORTED_IN_SNAPSHOT, added since the fix, stays in `codes`).

Failing test: parallel/test-v8-startup-snapshot-api —
`TypeError: ERR_NOT_BUILDING_SNAPSHOT is not a constructor` (stable over 2 runs).
