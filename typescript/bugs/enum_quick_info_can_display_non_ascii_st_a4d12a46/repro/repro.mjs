import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const src = 'enum E { A = "é", B = "日本" }\nE.A;\nE.B;\n';
const opts = { target: ts.ScriptTarget.ES2020 };
const host = {
  getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(src) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "a.ts",
  readFile: f => f === "a.ts" ? src : undefined,
};
const ls = ts.createLanguageService(host);
for (const m of ["A", "B"]) {
  const pos = src.lastIndexOf("E." + m) + 2;
  console.log(ts.displayPartsToString(ls.getQuickInfoAtPosition("a.ts", pos).displayParts));
}
