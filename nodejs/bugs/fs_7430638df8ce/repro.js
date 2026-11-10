'use strict';
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { spawn } = require('node:child_process');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'rw-'));
const file = path.join(dir, 'a');
const watcher = fs.watch(dir, { recursive: true });
watcher.on('change', () => {});
watcher.on('error', () => {});
const child = spawn(process.execPath, ['-e', `const fs=require('node:fs');for(let i=0;i<20000;i++){const fd=fs.openSync(${JSON.stringify(file)},'w');fs.writeSync(fd,Buffer.from('hello'));fs.closeSync(fd);fs.rmSync(${JSON.stringify(file)})}`], { stdio: 'inherit' });
child.on('exit', () => {
  watcher.close();
  fs.rmSync(dir, { recursive: true, force: true });
  console.log('ok');
});
