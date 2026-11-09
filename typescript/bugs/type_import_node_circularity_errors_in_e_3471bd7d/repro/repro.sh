#!/bin/bash
cat > run.cjs <<'J'
const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const files = ["types.ts", "index.ts"];
const host = ts.createCompilerHost({});
const p = ts.createProgram(files, {noEmit: true});
const sf = p.getSourceFile("index.ts");
for (const d of p.getSuggestionDiagnostics ? [] : []) {}
const ls = ts.createLanguageService({
  getCompilationSettings: () => ({}),
  getScriptFileNames: () => files,
  getScriptVersion: () => "1",
  getScriptSnapshot: f => fs.existsSync(f) ? ts.ScriptSnapshot.fromString(fs.readFileSync(f, "utf8")) : undefined,
  getCurrentDirectory: () => process.cwd(),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: ts.sys.fileExists, readFile: ts.sys.readFile,
});
for (const d of ls.getSuggestionDiagnostics("index.ts"))
  console.log(d.code, d.start, d.reportsDeprecated, ts.flattenDiagnosticMessageText(d.messageText, "\n"));
J
node run.cjs
