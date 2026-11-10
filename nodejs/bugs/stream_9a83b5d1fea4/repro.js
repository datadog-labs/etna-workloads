'use strict';
const { Utf8Stream, readFileSync } = require('node:fs');
const os = require('node:os'), path = require('node:path'), fs = require('node:fs');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'r-'));
const dest = path.join(dir, 'a.log');
const s = new Utf8Stream({ dest, sync: true, contentMode: 'buffer' });
s.on('ready', () => {
  try {
    s.write(Buffer.from('hello world\n'));
    s.end();
  } catch (e) { console.log('error', e.code || e.name); }
  s.on('finish', () => {
    console.log(JSON.stringify(fs.readFileSync(dest, 'utf8')));
    fs.rmSync(dir, { recursive: true });
  });
});
s.on('error', (e) => console.log('stream error', e.code || e.name));
