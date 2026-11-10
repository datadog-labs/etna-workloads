const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const pos = text.indexOf("upStatement") + "upStatement".length;
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => ({ strict: true }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
try {
  const c = ls.getCompletionsAtPosition("input.ts", pos, {});
  console.log(JSON.stringify(c && c.entries.map(e => e.name)));
} catch (e) { console.log("CRASH", e.message.split("\n")[0]); }
