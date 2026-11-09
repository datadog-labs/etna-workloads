const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const opts = { target: ts.ScriptTarget.ESNext };
const lib = ts.getDefaultLibFilePath(opts);
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : fs.existsSync(f) ? ts.ScriptSnapshot.fromString(fs.readFileSync(f, "utf8")) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => lib,
  fileExists: f => f === "input.ts" || fs.existsSync(f),
  readFile: f => f === "input.ts" ? text : fs.readFileSync(f, "utf8"),
};
const ls = ts.createLanguageService(host);
for (const d of ls.getSuggestionDiagnostics("input.ts"))
  console.log(d.code, ts.flattenDiagnosticMessageText(d.messageText, "\n"));
console.log("done");
