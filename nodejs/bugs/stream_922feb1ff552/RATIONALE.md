# Re-introduced bug
`pipeline()` no longer rejects when a stream it would pipe into is already closed/destroyed (issue #52622); the pipeline proceeds on a dead stream instead of failing with ERR_STREAM_UNABLE_TO_PIPE (hang/silent misbehaviour).

# Hunks
- lib/internal/streams/pipeline.js: removed the `if (next !== null && (next?.closed || next?.destroyed)) throw new ERR_STREAM_UNABLE_TO_PIPE()` check, the `const next = ...` line, and the ERR_STREAM_UNABLE_TO_PIPE import (corresponds to all three pipeline.js hunks of the fix).
- lib/internal/errors.js: removed the `E('ERR_STREAM_UNABLE_TO_PIPE', ...)` definition (corresponds to the errors.js hunk).

# Failing test
parallel/test-stream-pipeline: "not ok" — the new assert.rejects(/ERR_STREAM_UNABLE_TO_PIPE/) case no longer rejects with that error.
