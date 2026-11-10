import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const pos = text.indexOf("{\n    \n") + 6;
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ strict: true, lib: ["lib.d.ts"], noLib: true }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const c = ls.getCompletionsAtPosition("input.ts", pos, {});
console.log((c?.entries ?? []).map(e => e.name).join("\n"));
