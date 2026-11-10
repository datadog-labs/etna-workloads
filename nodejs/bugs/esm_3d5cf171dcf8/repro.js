'use strict';
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'race-'));
const w = (f, c) => {
  fs.mkdirSync(path.dirname(path.join(dir, f)), { recursive: true });
  fs.writeFileSync(path.join(dir, f), c);
};
w('node_modules/esm-pkg/index.mjs', 'export {}\n');
w('node_modules/esm-pkg/package.json', '{"name":"esm-pkg","exports":"./index.mjs"}');
w('node_modules/dual-pkg/index.cjs', "'use strict';\nrequire('esm-pkg');\n");
w('node_modules/dual-pkg/index.mjs', 'import "esm-pkg";\n');
w('node_modules/dual-pkg/package.json',
  '{"name":"dual-pkg","exports":{"import":"./index.mjs","require":"./index.cjs"}}');
w('node_modules/cjs-pkg/index.js', "'use strict';\nrequire('dual-pkg');\n");
w('main.cjs', 'import("dual-pkg");\nrequire("cjs-pkg");\n');
try {
  require(path.join(dir, 'main.cjs'));
  console.log('no error');
} catch (e) {
  console.log(e.code, e.name);
}
process.on('exit', () => fs.rmSync(dir, { recursive: true, force: true }));
