// The fix makes the trace_events binding expose hasAgent(), which lib/trace_events.js
// uses to throw ERR_TRACE_EVENTS_UNAVAILABLE when no tracing::Agent exists
// (embedder-owned V8 platform). Without it, the null agent reaches the binding.
const { spawnSync } = require('child_process');
const code = `
const { internalBinding } = require('internal/test/binding');
const b = internalBinding('trace_events');
console.log('hasAgent:', typeof b.hasAgent);
if (typeof b.hasAgent === 'function') console.log('hasAgent():', b.hasAgent());
`;
const r = spawnSync(process.execPath, ['--expose-internals', '--no-warnings', '-e', code], { encoding: 'utf8' });
process.stdout.write(r.stdout + r.stderr);
