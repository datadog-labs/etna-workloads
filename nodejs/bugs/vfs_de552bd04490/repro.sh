#!/bin/bash
# usage: bash repro.sh <node binary>
cat > repro_inner.js <<'JS'
const vfs = require('node:vfs');
const fsp = require('fs/promises');
(async () => {
  const v = vfs.create();
  v.writeFileSync('/a.txt', 'hello');
  const mp = v.mount();
  const fh = await fsp.open(mp + '/a.txt', 'r');
  console.log('class', fh.constructor.name);
  console.log('fd type', typeof fh.fd);
  try {
    console.log('read', await fh.readFile('utf8'));
    console.log('stat', typeof (await fh.stat()).size);
    await fh.close();
    console.log('closed');
  } catch (e) { console.log('err', e.code || e.message); }
  v.unmount();
})();
JS
"$1" --no-warnings --experimental-vfs repro_inner.js 2>&1; echo "exit=$?"
rm -f repro_inner.js
