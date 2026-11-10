const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const name = "/input.tsx";
const text = fs.readFileSync("input.tsx", "utf8");
const host = {
  getScriptFileNames: () => [name],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === name ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ jsx: ts.JsxEmit.Preserve }),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f === name,
  readFile: f => f === name ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("cl=") + 2;
const r = ls.getCompletionsAtPosition(name, pos, {
  jsxAttributeCompletionStyle: "braces",
  includeCompletionsWithSnippetText: true,
  includeCompletionsWithInsertText: true,
});
const e = r.entries.find(e => e.name === "className");
console.log(JSON.stringify({ name: e.name, insertText: e.insertText, isSnippet: e.isSnippet }));
