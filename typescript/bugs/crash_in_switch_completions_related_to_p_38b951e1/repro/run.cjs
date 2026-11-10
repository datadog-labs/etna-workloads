const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const opts = { target: ts.ScriptTarget.ES2020 };
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("('") + 2;
try {
  const r = ls.getCompletionsAtPosition("input.ts", pos, {});
  console.log(JSON.stringify(r && r.entries.map(e => e.name)));
} catch (e) { console.log("crash:", e instanceof Error ? "error" : e); }
