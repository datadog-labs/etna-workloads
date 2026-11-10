import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
"/node_modules/pkg/package.json": JSON.stringify({name:"pkg",type:"module",exports:{"./*":{types:"./types/*",default:"./dist/*"}}}),
"/node_modules/pkg/types/external.d.ts": "export declare function external(name: string): any;",
"/package.json": JSON.stringify({name:"self",type:"module",imports:{"#*":"./src/*"},dependencies:{pkg:"*"}}),
"/src/add.ts": "export function add(a: number, b: number) {}",
"/src/index.ts": "add;\nexternal;\n",
};
const opts = {module: ts.ModuleKind.Node18, allowImportingTsExtensions: true, noEmit:true, lib:["lib.es5.d.ts"]};
const host = {
  getCompilationSettings: () => opts,
  getScriptFileNames: () => ["/src/index.ts","/src/add.ts","/node_modules/pkg/types/external.d.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "/lib.es5.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
  directoryExists: d => Object.keys(files).some(f => f.startsWith(d.endsWith("/")?d:d+"/")) || d==="/",
  getDirectories: () => [],
  useCaseSensitiveFileNames: () => true,
};
const ls = ts.createLanguageService(host);
for (const pos of [1, files["/src/index.ts"].indexOf("external")+1]) {
  const fixes = ls.getCodeFixesAtPosition("/src/index.ts", pos, pos+ (pos===1?2:7), [2304], {}, {});
  for (const f of fixes) console.log(f.description);
}
