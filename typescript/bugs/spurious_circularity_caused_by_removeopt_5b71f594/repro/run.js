const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getCompilationSettings: () => ({ strict: true }),
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
ls.getEncodedSemanticClassifications("input.ts", { start: 0, length: 128 }, ts.SemanticClassificationFormat.TwentyTwenty);
for (const d of ls.getSemanticDiagnostics("input.ts"))
  console.log(d.code, ts.flattenDiagnosticMessageText(d.messageText, "\n"));
console.log("done");
