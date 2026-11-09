import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const opts = { target: 99 };
const host = {
  getScriptFileNames: () => ["input.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "", getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const hints = ls.provideInlayHints("input.ts", { start: 0, length: text.length }, { includeInlayVariableTypeHints: true, interactiveInlayHints: true });
for (const h of hints) console.log(JSON.stringify(h.displayParts.map(p => p.text).join("")));
