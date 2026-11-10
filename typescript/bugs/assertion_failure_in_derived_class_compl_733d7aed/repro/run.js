const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const pos = text.indexOf("/**/");
const host = {
  getCompilationSettings: () => ({}),
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const r = ls.getCompletionsAtPosition("input.ts", pos, {
  includeCompletionsWithInsertText: true,
  includeCompletionsWithSnippetText: true,
  includeCompletionsWithClassMemberSnippets: true,
});
for (const e of r.entries.filter(e => e.name === "pipe")) console.log(e.insertText);
