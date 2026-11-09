import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = "function f(a: number, b: string) {}\n";
const host = {
  getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: () => ts.ScriptSnapshot.fromString(text),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: () => true, readFile: () => text,
};
const ls = ts.createLanguageService(host);
const r = ls.getDocCommentTemplateAtPosition("a.ts", 0, {}, { newLineCharacter: "\r\n" });
console.log(JSON.stringify(r));
