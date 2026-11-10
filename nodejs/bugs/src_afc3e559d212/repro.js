// Runs the embedder-level cctest next to the node binary (JS alone cannot
// reuse an isolate for a second Environment after node::Stop()).
const { spawnSync } = require('child_process');
const path = require('path');
const cctest = path.join(path.dirname(process.execPath), 'cctest');
const r = spawnSync(cctest,
  ['--gtest_filter=EnvironmentTest.StopFromExitHandlerDoesNotLeakIntoNextEnvironment'],
  { encoding: 'utf8' });
const out = (r.stdout + r.stderr);
console.log('test passed:', /\[  PASSED  \] 1 test/.test(out));
console.log('exit status zero:', r.status === 0);
