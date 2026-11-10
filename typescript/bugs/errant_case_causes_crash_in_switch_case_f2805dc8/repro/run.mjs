import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = `switch ((null as any as 123 | 456)) {
    case "foo!":
    case
}
`;
const pos = text.indexOf("case\n") + 4;
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({ lib: ["lib.es5.d.ts"] }),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f === "a.ts", readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
const prefs = { includeCompletionsWithInsertText: true };
const c = ls.getCompletionsAtPosition("a.ts", pos, prefs);
for (const e of c?.entries ?? []) {
  if (!e.source && !e.isSnippet && !e.data) continue;
  console.log("entry", e.name, e.source, JSON.stringify(e.data));
}
for (const e of c?.entries ?? []) {
  if (e.name.startsWith("case ") || e.source) {
    try { console.log(JSON.stringify(ls.getCompletionEntryDetails("a.ts", pos, e.name, {}, e.source, prefs, e.data))); }
    catch (err) { console.log("error", err.message); }
  }
}
