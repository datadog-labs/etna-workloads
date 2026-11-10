'use strict';
const { spawnSync } = require('child_process');
const r = spawnSync(process.execPath, ['--disallow-code-generation-from-strings', '-e',
  `try { console.log('eval result', eval('1+1')); } catch (e) { console.log('threw', e.name); }
   try { console.log('Function result', new Function('return 2')()); } catch (e) { console.log('threw', e.name); }`],
  { encoding: 'utf8' });
process.stdout.write(r.stdout + r.stderr);
console.log('status', r.status);
