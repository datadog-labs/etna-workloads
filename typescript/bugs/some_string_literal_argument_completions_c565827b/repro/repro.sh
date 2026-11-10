#!/bin/bash
cat > run.cjs <<'EOS'
const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const opts = { strict: true, target: ts.ScriptTarget.ES2022 };
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
for (const m of ['parse("foo|', 'prop: "foo|']) {
  const pos = text.indexOf(m) + m.length;
  const c = ls.getCompletionsAtPosition("input.ts", pos, {});
  console.log(m, JSON.stringify(c && c.entries.map(e => e.name).sort()));
}
EOS
node run.cjs
