'use strict';
const fs = require('fs'), os = require('os'), path = require('path');
const { spawnSync } = require('child_process');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const gen = path.join(dir, 'gen.js');
fs.writeFileSync(gen, `const{getCallSites}=require('node:util');function foo(){process.stdout.write(JSON.stringify(getCallSites({sourceMap:true})[0]))}foo();
//# sourceMappingURL=gen.map
`);
fs.writeFileSync(path.join(dir, 'gen.map'), JSON.stringify({
  version: 3,
  sources: ['orig.js'],
  sourcesContent: ["const { getCallSites } = require('node:util'); function foo() { process.stdout.write(JSON.stringify(getCallSites({ sourceMap: true })[0])); } foo();"],
  mappings: 'AAAA,KAAM,CAAE,YAAa,EAAI,QAAQ,WAAW,EAAG,SAAS,KAAM,CAAE,QAAQ,OAAO,MAAM,KAAK,UAAU,aAAa,CAAE,UAAW,EAAK,CAAC,EAAE,CAAC,CAAC,CAAC,CAAG,CAAE,IAAI',
  names: [],
}));
const r = spawnSync(process.execPath, ['--enable-source-maps', gen], { encoding: 'utf8' });
fs.rmSync(dir, { recursive: true, force: true });
console.log('status', r.status);
console.log('functionName', JSON.parse(r.stdout).functionName);
