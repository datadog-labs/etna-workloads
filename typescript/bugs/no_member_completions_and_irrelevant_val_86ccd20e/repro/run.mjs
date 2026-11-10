import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = `interface I {\n    method(): void;\n}\n\nexport class C implements I {\n    property = "foo"\n    \n}\n`;
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "a.ts", readFile: f => f === "a.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const r = ls.getCompletionsAtPosition("a.ts", text.indexOf("    \n}") + 4, {});
console.log(r ? r.entries.map(e => e.name).filter(n => ["method","private","public","readonly"].includes(n)).sort().join(",") : "none");
