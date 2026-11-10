import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
try {
  const hints = ls.provideInlayHints("input.ts", { start: 0, length: text.length }, { includeInlayFunctionParameterTypeHints: true, interactiveInlayHints: true });
  console.log(JSON.stringify(hints.map(h => h.displayParts ?? h.text)));
} catch (e) { console.log("crash:", e.message.split("\n")[0]); }
