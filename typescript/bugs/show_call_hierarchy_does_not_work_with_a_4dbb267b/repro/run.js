const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
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
const pos = text.indexOf("caller");
console.log(JSON.stringify(ls.prepareCallHierarchy("input.ts", pos), null, 1));
const pos2 = text.indexOf("callee");
console.log(JSON.stringify(ls.provideCallHierarchyOutgoingCalls("input.ts", pos), null, 1));
