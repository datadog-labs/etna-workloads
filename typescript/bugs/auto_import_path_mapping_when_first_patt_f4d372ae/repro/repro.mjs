import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/package1/file1.js": "bar",
  "/package2/file1.js": "export const bar = 0;",
};
const options = { checkJs: true, allowJs: true, baseUrl: "/package1", paths: { "package1/*": ["./*"], "package2/*": ["../package2/*"] } };
const host = {
  getCompilationSettings: () => options,
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const r = ls.getCompletionsAtPosition("/package1/file1.js", 3, { includeCompletionsForModuleExports: true, importModuleSpecifierPreference: "shortest" });
for (const e of (r?.entries ?? []).filter(e => e.name === "bar"))
  console.log(e.name, e.source, e.data?.moduleSpecifier);
