import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files = { "/b.ts": "a" };
for (let i = 0; i < 250; i++) files[`/lib/a_${i}.ts`] = `export const aa_${i}__0 = ${i};`;
let cache;
const host = {
  getCompilationSettings: () => ({ module: ts.ModuleKind.CommonJS, moduleResolution: ts.ModuleResolutionKind.Node10, target: ts.ScriptTarget.ES2020 }),
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => String(files["/b.ts"].length),
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
  getIncompleteCompletionsCache: () => ({ get: () => cache, set: v => { cache = v; }, clear: () => { cache = undefined; } }),
};
const ls = ts.createLanguageService(host);
const prefs = { allowIncompleteCompletions: true, includeCompletionsForModuleExports: true, includeCompletionsWithInsertText: true };
function show(label, r) {
  console.log(label, JSON.stringify({ flags: r.flags, optionalReplacementSpan: r.optionalReplacementSpan, n: r.entries.length, inc: r.isIncomplete }));
}
show("first", ls.getCompletionsAtPosition("/b.ts", 1, { ...prefs, triggerKind: ts.CompletionTriggerKind?.Invoked }));
files["/b.ts"] = "aa";
show("second", ls.getCompletionsAtPosition("/b.ts", 2, { ...prefs, triggerKind: 3 }));
