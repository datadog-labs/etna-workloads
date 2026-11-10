'use strict';
if (process.argv[2] === 'sub') {
  process.reallyExit = function() { console.log('really exited'); };
  process.exit();
} else {
  const r = require('child_process').spawnSync(process.execPath, [__filename, 'sub']);
  console.log(JSON.stringify(r.stdout.toString()), r.status);
}
