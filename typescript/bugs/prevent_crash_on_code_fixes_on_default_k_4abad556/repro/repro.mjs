import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = "export { default };\n";
const opts = { target: ts.ScriptTarget.ES2020, module: ts.ModuleKind.ESNext };
const host = {
  getScriptFileNames: () => ["file1.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "file1.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "file1.ts",
  readFile: f => f === "file1.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
try {
  const r = ls.getCombinedCodeFix({ type: "file", fileName: "file1.ts" }, "fixMissingImport", {}, {});
  console.log("changes:", JSON.stringify(r.changes));
} catch (e) { console.log("threw:", String(e.message).split("\n")[0]); }
try {
  const fixes = ls.getCodeFixesAtPosition("file1.ts", 9, 16, [2304, 2305, 2661], {}, {});
  console.log("fixes:", fixes.length);
} catch (e) { console.log("threw:", String(e.message).split("\n")[0]); }
