import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/a.ts": "export function foo() { }\nexport function bar() {}\n",
  "/b.ts": 'export function baz() { }\nexport {\n    foo,\n    bar,\n} from "./a";\n',
};
const host = {
  getCompilationSettings: () => ({ module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ESNext }),
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
  useCaseSensitiveFileNames: () => true,
};
const ls = ts.createLanguageService(host);
const start = files["/a.ts"].indexOf("export function bar");
const range = { pos: start, end: start + "export function bar() {}".length };
const prefs = { allowTextChangesInNewFiles: true };
const refs = ls.getApplicableRefactors("/a.ts", range, prefs, undefined, undefined, true);
const r = refs.find(x => x.name === "Move to file");
const act = r.actions[0];
const edits = ls.getEditsForRefactor("/a.ts", { }, range, r.name, act.name, prefs, { targetFile: "/b.ts" });
for (const fe of edits.edits) {
  let t = files[fe.fileName] ?? "";
  for (const c of [...fe.textChanges].sort((a, b) => b.span.start - a.span.start))
    t = t.slice(0, c.span.start) + c.newText + t.slice(c.span.start + c.span.length);
  console.log("== " + fe.fileName + "\n" + t);
}
