import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = `const d = 1
d
const e = 1
`;
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "a.ts", readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
for (const pos of [text.indexOf("d\n")+1, text.length]) {
  const r = ls.getCompletionsAtPosition("a.ts", pos, {});
  for (const n of ["d","e"]) {
    const e = r.entries.find(x => x.name === n);
    const det = ls.getCompletionEntryDetails("a.ts", pos, n, {}, undefined, {}, undefined);
    console.log(pos, n, e && e.kind, det && ts.displayPartsToString(det.displayParts));
  }
}
