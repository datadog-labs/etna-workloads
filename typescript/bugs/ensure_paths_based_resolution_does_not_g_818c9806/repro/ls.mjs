import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
import fs from "fs";
const root = process.cwd();
const files = ["packages/app/lib/index.ts","packages/common/lib.ts"].map(f=>root+"/"+f);
const cfg = ts.parseJsonConfigFileContent(ts.readConfigFile("packages/app/tsconfig.json", ts.sys.readFile).config, ts.sys, root+"/packages/app");
const host = {
  getCompilationSettings: () => cfg.options,
  getScriptFileNames: () => files,
  getScriptVersion: () => "1",
  getScriptSnapshot: f => ts.sys.fileExists(f) ? ts.ScriptSnapshot.fromString(ts.sys.readFile(f)) : undefined,
  getCurrentDirectory: () => root,
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: ts.sys.fileExists, readFile: ts.sys.readFile, readDirectory: ts.sys.readDirectory,
  directoryExists: ts.sys.directoryExists, getDirectories: ts.sys.getDirectories,
};
const ls = ts.createLanguageService(host);
const f = files[0];
const fixes = ls.getCodeFixesAtPosition(f, 0, 7, [2304], {}, { importModuleSpecifierPreference: "non-relative" });
console.log(fixes.map(x=>x.description));
const c = ls.getCompletionsAtPosition(f, 0, { includeCompletionsForModuleExports: true, importModuleSpecifierPreference: "non-relative" });
const e = c?.entries.find(e=>e.name==="Tooltip");
console.log(e && e.source);
