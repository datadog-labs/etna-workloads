import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = `function f() {
    let g = <T>(x: T) => x;
    return g;
}
`;
const start = text.indexOf("<T>"), end = text.indexOf("x;\n") + 1;
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "a.ts", readFile: f => f === "a.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const refs = ls.getApplicableRefactors("a.ts", { pos: start, end }, {});
for (const r of refs) for (const a of r.actions) console.log(a.name, a.description);
const e = ls.getEditsForRefactor("a.ts", {}, { pos: start, end }, "Extract Symbol", "function_scope_1", {});
for (const c of e?.edits ?? []) for (const t of c.textChanges) console.log(JSON.stringify(t.newText));
