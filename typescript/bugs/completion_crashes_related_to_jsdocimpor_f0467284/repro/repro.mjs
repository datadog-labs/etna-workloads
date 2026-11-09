import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = '/** @import { MyUnion } from "" */\n';
const files = { "index.js": text, "node_modules/pkg/index.d.ts": "export type MyUnion = string | number;" };
const host = {
  getScriptFileNames: () => ["index.js"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ allowJs: true, checkJs: true, strict: true, module: ts.ModuleKind.NodeNext, moduleResolution: ts.ModuleResolutionKind.NodeNext }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
try {
  const pos = text.indexOf('""') + 1;
  const c = ls.getCompletionsAtPosition("index.js", pos, {});
  console.log(c ? c.entries.map(e => e.name).join(",") : "none");
} catch (e) { console.log("crash:", e.message.split("\n")[0]); }
