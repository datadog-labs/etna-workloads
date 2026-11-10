const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => ".",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
try {
  const qi = ls.getQuickInfoAtPosition("input.ts", text.lastIndexOf("x"));
  console.log(ts.displayPartsToString(qi.displayParts));
} catch (e) { console.log("CRASH:", e instanceof RangeError ? "RangeError" : e.message); }
