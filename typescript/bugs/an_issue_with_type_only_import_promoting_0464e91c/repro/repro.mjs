import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/index.ts": 'import { TwistyAlgEditor, type TwistyPlayer } from "./other-file";\nnew TwistyPlayer();',
  "/other-file.ts": "export class TwistyAlgEditor {}\nexport class TwistyPlayer {}",
};
const opts = { module: ts.ModuleKind.ES2015, target: ts.ScriptTarget.ES2015 };
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
const d = ls.getSemanticDiagnostics("/index.ts").find(x => x.code === 1361);
const fixes = ls.getCodeFixesAtPosition("/index.ts", d.start, d.start + d.length, [d.code], {}, {});
for (const f of fixes) {
  console.log(f.description);
  for (const c of f.changes) for (const t of c.textChanges) console.log(JSON.stringify(t));
}
