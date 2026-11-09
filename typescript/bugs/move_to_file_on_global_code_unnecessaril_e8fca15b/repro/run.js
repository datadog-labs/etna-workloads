const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("a.ts", "utf8");
const files = { "/a.ts": text };
const host = {
  getCompilationSettings: () => ({ target: ts.ScriptTarget.ES2015 }),
  getScriptFileNames: () => ["/a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => { const t = files[f] ?? (fs.existsSync(f) ? fs.readFileSync(f, "utf8") : undefined); return t === undefined ? undefined : ts.ScriptSnapshot.fromString(t); },
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f in files || fs.existsSync(f),
  readFile: f => files[f] ?? fs.readFileSync(f, "utf8"),
};
const ls = ts.createLanguageService(host);
const range = { pos: 0, end: text.length };
const edits = ls.getEditsForRefactor("/a.ts", {}, range, "Move to file", "Move to file", undefined, { targetFile: "/String.ts" });
for (const fe of edits.edits) { console.log("== " + fe.fileName); for (const t of fe.textChanges) console.log(JSON.stringify(t.newText)); }
