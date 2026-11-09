import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
 "/a.ts": "export class A {}\n",
 "/b.ts": "export function f(a: any) {}\n",
 "/c.ts": "import { A } from './a';\nimport { f } from './b';\n\nf({}, new A());\n",
};
const opts = { module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ESNext, strict: true };
const host = {
 getScriptFileNames: () => Object.keys(files),
 getScriptVersion: () => "1",
 getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
 getCurrentDirectory: () => "/",
 getCompilationSettings: () => opts,
 getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => files[f] !== undefined,
 readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const diags = ls.getSemanticDiagnostics("/c.ts").filter(d => d.code === 2554);
const fixes = ls.getCodeFixesAtPosition("/c.ts", diags[0].start, diags[0].start + diags[0].length, [2554], {}, {});
for (const fx of fixes) {
  console.log(fx.description);
  for (const c of fx.changes) { console.log(c.fileName); for (const t of c.textChanges) console.log(JSON.stringify(t)); }
}
