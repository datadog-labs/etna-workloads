import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/src/globals.d.ts": "export {};\ndeclare global {\n    interface Disposable {\n        [Symbol.dispose](): void;\n    }\n}\n",
  "/src/test.ts": "interface Disposable {\n    (): string;\n}\nexport interface EditingService extends Disposable { }\n",
};
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ lib: ["lib.esnext.d.ts"], module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ESNext }),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => files[f] !== undefined || ts.sys.fileExists(f),
  readFile: f => files[f] ?? ts.sys.readFile(f),
};
const ls = ts.createLanguageService(host);
const t = files["/src/test.ts"];
const pos = t.indexOf("export interface") + 17 + 10;
const range = { pos, end: pos + "EditingService".length };
const refs = ls.getApplicableRefactors("/src/test.ts", range, { allowTextChangesInNewFiles: true }, "invoked", undefined, true);
const r = refs.find(x => x.actions.some(a => a.name === "Move to a new file"));
const e = ls.getEditsForRefactor("/src/test.ts", {}, range, r.name, "Move to a new file", {});
for (const fe of e.edits) { console.log("== " + fe.fileName); for (const c of fe.textChanges) console.log(JSON.stringify(c.newText)); }
