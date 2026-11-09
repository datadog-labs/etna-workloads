import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files = { "/a.ts": "export function satisfies() {}\nexport function as() {}\n", "/b.ts": "1 sat\n1 a" };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ lib: ["lib.es5.d.ts"] }),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
for (const [pos, p] of [[9, "sat"], [files["/b.ts"].length, "a"]]) {
  const r = ls.getCompletionsAtPosition("/b.ts", pos, { includeCompletionsForModuleExports: true });
  console.log(p, (r?.entries ?? []).filter(e => e.name === "satisfies" || e.name === "as").map(e => e.name + " " + (e.source ?? "") + " " + !!e.hasAction));
}
