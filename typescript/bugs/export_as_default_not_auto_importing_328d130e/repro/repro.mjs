import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/foo.ts": "const foo = 'foo'\nexport { foo as default }\n",
  "/index.ts": "foo",
};
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ESNext }),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const prefs = { includeCompletionsForModuleExports: true, includeCompletionsWithInsertText: true };
const c = ls.getCompletionsAtPosition("/index.ts", 3, prefs);
const e = c.entries.find(x => x.name === "foo" && x.source);
console.log(e && e.source);
const d = ls.getCompletionEntryDetails("/index.ts", 3, "foo", {}, e && e.source, prefs, e && e.data);
console.log(d && JSON.stringify(d.codeActions && d.codeActions.map(a => a.changes.map(c => c.textChanges))));
