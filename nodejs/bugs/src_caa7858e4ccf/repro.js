// Runs the cctest that shares one IsolateData between two Environments
// (the only way to trigger this bug) and reports only pass/fail.
const { spawnSync } = require('child_process');
const path = require('path');
const cctest = path.join(path.dirname(process.execPath), 'cctest');
const r = spawnSync(cctest,
  ['--gtest_filter=EnvironmentTest.SharedIsolateDataLoadsBindingsTwice'],
  { encoding: 'utf8' });
const ok = r.status === 0 && /\[  PASSED  \] 1 test/.test(r.stdout);
console.log(ok ? 'second Environment loaded bindings: OK' :
                 'second Environment aborted/failed');
process.exitCode = ok ? 0 : 1;
