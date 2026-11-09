import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = 'type T = "a\\"b" | "c\\nd" | "e\'f";\ndeclare function f(x: T): void;\nf("");\n';
const host = {
  getCompilationSettings: () => ({}), getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1", getScriptSnapshot: n => n === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getDefaultLibFileName: () => "lib.d.ts",
  fileExists: n => n === "a.ts", readFile: n => n === "a.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const r = ls.getCompletionsAtPosition("a.ts", text.indexOf('f("') + 3, {});
console.log(r.entries.map(e => e.name).join("\n"));
