import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = require("fs").readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("f(");
console.log(ts.displayPartsToString(ls.getQuickInfoAtPosition("input.ts", pos).displayParts));
const p = ls.getProgram(), c = p.getTypeChecker();
const sf = p.getSourceFile("input.ts");
console.log(c.typeToString(c.getTypeAtLocation(sf.statements[0].name)));
