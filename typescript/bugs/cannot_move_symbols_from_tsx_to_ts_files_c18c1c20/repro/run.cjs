const ts = require(process.env.TYPESCRIPT);
const files = {"/a.tsx":"export const x = 1;\nexport function f() { return 2; }\n","/b.ts":"export const y = 1;\n"};
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({jsx: ts.JsxEmit.Preserve}),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const r = ls.getMoveToRefactoringFileSuggestions("/a.tsx", {pos:0,end:19}, {});
console.log(JSON.stringify(r.files));
