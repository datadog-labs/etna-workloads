import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getCompilationSettings: () => ({}),
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("async f") + 7;
const r = ls.getCompletionsAtPosition("input.ts", pos, {});
console.log((r?.entries ?? []).filter(e => e.name === "foo").map(e => e.name + " " + e.sortText).join("\n") || "no foo");
