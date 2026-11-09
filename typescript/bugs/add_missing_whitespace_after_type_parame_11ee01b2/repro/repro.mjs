import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = "function test1() {\n  return function <const T>(a: T) {};\n}\n";
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "a.ts",
  readFile: f => f === "a.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const hints = ls.provideInlayHints("a.ts", { start: 0, length: text.length }, {
  interactiveInlayHints: true, includeInlayFunctionLikeReturnTypeHints: true });
for (const h of hints) console.log(JSON.stringify(h.displayParts ? h.displayParts.map(p => p.text).join("") : h.text));
