# Bug
With the permission model enabled, REPL autocomplete/preview calls `sendInspectorCommand`, which connects an inspector session. The inspector is unavailable under the permission model, so `Session.connect` throws ERR_ACCESS_DENIED and crashes the REPL on Tab/preview.

# Change (lib/internal/util/inspector.js)
- Removed `const permission = require('internal/process/permission');` (fix hunk 1; the file now has an extra `assignFunctionName` import line, so the hunk was re-expressed).
- Removed the `if (permission.isEnabled()) return onError();` guard in `sendInspectorCommand` (fix hunk 2), so the inspector is used even when permissions are enabled.

# Failing test
parallel/test-repl-permission-model: `Error: Access to this API has been restricted. Use --allow-inspector to manage permissions.` (ERR_ACCESS_DENIED, from Session.connect via sendInspectorCommand). Failed on two runs.
