const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const code = `const i=require('inspector');
try{i.open(0,undefined,false);console.log('opened',typeof i.url());
try{i.open(0,undefined,false);}catch(e){console.log('second',e.code);}
i.close();}catch(e){console.log('error',e.code);}`;
const r = spawnSync(process.execPath, ['-e', code], {
  env: { ...process.env, NODE_V8_COVERAGE: fs.mkdtempSync(os.tmpdir() + '/cov-') },
  encoding: 'utf8',
});
console.log(r.status, r.stdout);
