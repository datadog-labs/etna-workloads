const ts = require(process.env.TYPESCRIPT);
const files = {
  "/Work/pkg1/package.json": '{"name":"x"}',
  "/Work/pkg1/src/main.ts": "import { P } from './utils';\nexport class Sub extends P(Object) { id: string; }\n",
  "/Work/pkg1/src/utils/index.ts": "import { R } from './type-helpers';\nexport function P<T>(c: any) { abstract class A {} return A as R; }\n",
  "/Work/pkg1/src/utils/type-helpers.ts": "export type R = { new (...args: any[]): any };\n",
};
const norm = p => p.toLowerCase();
const map = new Map(Object.entries(files).map(([k, v]) => [norm(k), v]));
const dirs = new Set(); for (const k of map.keys()) { let d = k; while ((d = d.slice(0, d.lastIndexOf("/"))) ) dirs.add(d); } dirs.add("");dirs.add("/");
const opts = { declaration: true, emitDeclarationOnly: true, baseUrl: "/Work/pkg1", module: ts.ModuleKind.CommonJS, moduleResolution: ts.ModuleResolutionKind.Node10, outDir: "/Work/pkg1/dist", noLib: true, types: [] , strict: false, ignoreDeprecations: "6.0"};
const out = {};
const host = {
  getSourceFile: (f, l) => map.has(norm(f)) ? ts.createSourceFile(f, map.get(norm(f)), l) : undefined,
  getDefaultLibFileName: () => "/lib.d.ts",
  writeFile: (f, t) => { out[f] = t; },
  getCurrentDirectory: () => "/Work/pkg1",
  getDirectories: () => [],
  fileExists: f => map.has(norm(f)),
  readFile: f => map.get(norm(f)),
  directoryExists: d => dirs.has(norm(d)),
  getCanonicalFileName: norm,
  useCaseSensitiveFileNames: () => false,
  getNewLine: () => "\n",
};
const prog = ts.createProgram(["/Work/pkg1/src/main.ts"], opts, host);
prog.emit();
for (const k of Object.keys(out).sort()) console.log("//", k, "\n" + out[k]);
