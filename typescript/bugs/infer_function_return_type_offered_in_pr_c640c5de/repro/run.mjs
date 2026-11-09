import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getCompilationSettings: () => ({}), getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1", getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "", getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf(";") + 1;
const r = ls.getApplicableRefactors("input.ts", { pos, end: pos }, { allowTextChangesInNewFiles: true }, undefined, "refactor.rewrite.function.returnType");
console.log(JSON.stringify(r.map(x => x.actions.map(a => a.name))));
