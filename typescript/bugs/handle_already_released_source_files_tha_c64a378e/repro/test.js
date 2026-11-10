const ts = require(process.env.TYPESCRIPT);
let kind = ts.ScriptKind.TS, bver = 1, ver = 1;
const files = { "/a.ts": "export const a = 1;\n", "/c.ts": "export const c = 2;\n", "/b.ts": "import {a} from './a'; export const b = a;\n" };
const host = {
  getCompilationSettings: () => ({ allowJs: true }),
  getScriptFileNames: () => ["/b.ts"],
  getScriptVersion: f => f === "/a.ts" ? String(ver) : f === "/b.ts" ? "b" + bver : "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getScriptKind: f => f === "/a.ts" ? kind : ts.ScriptKind.TS,
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files, readFile: f => files[f],
};
const ls = ts.createLanguageService(host, ts.createDocumentRegistry());
try {
  console.log(ls.getSemanticDiagnostics("/b.ts").length);
  kind = ts.ScriptKind.JS; ver = 2; bver = 2;
  files["/b.ts"] = "import {a} from './a'; import {c} from './c'; export const b = a + c;\n";
  console.log(ls.getSemanticDiagnostics("/b.ts").length);
  console.log(ls.getProgram().getSourceFile("/a.ts").scriptKind);
} catch (e) { console.log("error:", e.message.split("\n")[0]); }
