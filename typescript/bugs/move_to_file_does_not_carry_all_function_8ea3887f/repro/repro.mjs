import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = `function add(x: number, y: number): number;
function add(x: string, y: string): string;
function add(x: any, y: any) {
    return x + y;
}
`;
const files = { "/a.ts": text };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const range = { pos: 0, end: text.indexOf("\n") };
const edits = ls.getEditsForRefactor("/a.ts", {}, range, "Move to a new file", "Move to a new file", { allowTextChangesInNewFiles: true });
for (const e of edits?.edits ?? []) {
  console.log("== " + e.fileName);
  for (const c of e.textChanges) console.log(JSON.stringify(c.newText));
}
