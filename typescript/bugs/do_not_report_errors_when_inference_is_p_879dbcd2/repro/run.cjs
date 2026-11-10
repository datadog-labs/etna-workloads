const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const opts = { strict: true, noLib: true };
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
ls.getCompletionsAtPosition("input.ts", text.indexOf("bar") + 3, {});
for (const d of ls.getSemanticDiagnostics("input.ts"))
  console.log(d.start, ts.flattenDiagnosticMessageText(d.messageText, "\n"));
console.log("done");
