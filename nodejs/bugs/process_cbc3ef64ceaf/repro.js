const { spawnSync } = require('child_process');
const r = spawnSync(process.execPath, ['-e', `
process.stdout.on('error', (e) => { process.stderr.write('stdout error: ' + e.code + '\\n'); });
process.stderr.on('error', (e) => { process.stderr.write('stderr error: ' + e.code + '\\n'); });
process.stdout.destroy();
process.stderr.destroy();
process.stdout.write('still works\\n');
`], { encoding: 'utf8' });
console.log('status', r.status);
console.log('stdout', JSON.stringify(r.stdout));
console.log('stderr', JSON.stringify(r.stderr));
