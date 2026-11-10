import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("(a, b)") + 2;
const r = ls.getSignatureHelpItems("input.ts", pos, {});
console.log(r ? JSON.stringify({ idx: r.argumentIndex, count: r.argumentCount, items: r.items.map(i => i.prefixDisplayParts.concat(i.parameters.flatMap(p=>p.displayParts)).map(d=>d.text).join("")) }) : "no signature help");
