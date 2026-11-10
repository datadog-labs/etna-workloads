import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = "subTitle:\nexport const title: string\n";
const host = {
  getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "a.ts",
  readFile: f => f === "a.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
try {
  const r = ls.getDocumentHighlights("a.ts", text.indexOf("export") + 2, ["a.ts"]);
  console.log(JSON.stringify(r));
} catch (e) { console.log("threw:", e.message.split("\n")[0]); }
