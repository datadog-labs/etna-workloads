const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const files = ["tokenizer.ts", "expression.ts"];
const host = {
  getScriptFileNames: () => files,
  getScriptVersion: () => "1",
  getScriptSnapshot: f => fs.existsSync(f) ? ts.ScriptSnapshot.fromString(fs.readFileSync(f, "utf8")) : undefined,
  getCurrentDirectory: () => process.cwd(),
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => fs.existsSync(f),
  readFile: f => fs.readFileSync(f, "utf8"),
};
const ls = ts.createLanguageService(host);
const pos = fs.readFileSync("expression.ts", "utf8").indexOf("/**/");
try {
  const r = ls.getCompletionsAtPosition("expression.ts", pos, {
    includeCompletionsWithInsertText: true,
    includeCompletionsWithClassMemberSnippets: true,
  }, ts.getDefaultFormatCodeSettings("\n"));
  const e = r.entries.find(e => e.name === "errorBuilder");
  console.log(JSON.stringify(e.insertText));
} catch (err) {
  console.log("crashed");
}
