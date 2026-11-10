import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = "\ntype foo = any;\ndeclare const foo: any;\n";
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({ noLib: true }),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "a.ts", readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
try {
  const c = ls.getCompletionsAtPosition("a.ts", 0, {});
  for (const e of c.entries.filter(e => e.name === "foo")) {
    const d = ls.getCompletionEntryDetails("a.ts", 0, "foo", {}, e.source, {}, e.data);
    console.log(e.name, JSON.stringify(d && ts.displayPartsToString(d.displayParts)));
  }
} catch (e) { console.log("threw", e.constructor.name); }
