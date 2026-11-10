import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
 "/a.ts": "export function f() {}\n",
 "/b.ts": 'import { f } from "./a";\nexport interface I {}\ntype f = number;\nexport { f };\n',
 "/c.ts": 'import { I, f } from "./b";\nexport { type I, f };\n',
};
const opts = { verbatimModuleSyntax: true, module: ts.ModuleKind.ESNext, moduleResolution: ts.ModuleResolutionKind.Bundler, target: ts.ScriptTarget.ESNext };
const host = {
 getCompilationSettings: () => opts, getScriptFileNames: () => Object.keys(files),
 getScriptVersion: () => "1", getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
 getCurrentDirectory: () => "/", getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => f in files, readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
for (const d of ls.getSemanticDiagnostics("/c.ts")) {
  console.log(d.code, d.start);
  const fixes = ls.getCodeFixesAtPosition("/c.ts", d.start, d.start + d.length, [d.code], {}, {});
  for (const f of fixes) console.log(" fix:", f.description);
}
