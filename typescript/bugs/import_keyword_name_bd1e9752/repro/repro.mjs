import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/file.ts": "export var x = 10;\nexport { x as await, x as interface };\n",
  "/a.ts": "import {  } from \"./file\";\n",
};
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ module: ts.ModuleKind.ESNext }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const c = ls.getCompletionsAtPosition("/a.ts", 9, {includeCompletionsWithInsertText:true});
for (const e of c.entries) if (e.name !== "type") console.log(e.name, JSON.stringify(e.insertText));
