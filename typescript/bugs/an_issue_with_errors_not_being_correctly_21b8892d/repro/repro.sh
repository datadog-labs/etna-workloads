#!/bin/bash
cat > run.cjs <<'JS'
const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const pos = text.indexOf('"BARx"') + 5;
const opts = { strict: true, target: ts.ScriptTarget.ES2022 };
const host = {
  getCompilationSettings: () => opts,
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const c = ls.getCompletionsAtPosition("input.ts", pos, {});
console.log("completions:", c ? c.entries.map(e => e.name).sort().join(",") : "none");
for (const d of ls.getSemanticDiagnostics("input.ts"))
  console.log("diag", d.code, ts.flattenDiagnosticMessageText(d.messageText, "\n").split("\n")[0]);
JS
node run.cjs
