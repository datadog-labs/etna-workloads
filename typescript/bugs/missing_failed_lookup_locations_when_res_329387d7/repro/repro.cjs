const ts = require(process.env.TYPESCRIPT);
const files = {
  "/a/b/c/d/e/package.json": JSON.stringify({name:"app",imports:{"#utils":"lodash"}}),
  "/a/b/node_modules/lodash/index.d.ts": "export function add(a: number, b: number): number;",
  "/a/b/c/d/e/index.ts": 'import { add } from "#utils";',
};
const host = { fileExists: f => f in files, readFile: f => files[f], directoryExists: d => Object.keys(files).some(f => f.startsWith(d + "/")), realpath: p => p, getCurrentDirectory: () => "/" };
const r = ts.resolveModuleName("#utils", "/a/b/c/d/e/index.ts", { module: ts.ModuleKind.NodeNext, moduleResolution: ts.ModuleResolutionKind.NodeNext }, host);
console.log(r.resolvedModule && r.resolvedModule.resolvedFileName);
console.log((r.failedLookupLocations || []).join("\n"));
