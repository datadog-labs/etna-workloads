const ts = require(process.env.TYPESCRIPT);
const path = require("path");
const root = process.cwd();
const cfgPath = path.join(root, "web/tsconfig.json");
const cfg = ts.getParsedCommandLineOfConfigFile(cfgPath, {}, {...ts.sys, onUnRecoverableConfigFileDiagnostic(){}});
const host = {
  getCompilationSettings: () => cfg.options,
  getScriptFileNames: () => cfg.fileNames,
  getScriptVersion: () => "1",
  getScriptSnapshot: f => ts.sys.fileExists(f) ? ts.ScriptSnapshot.fromString(ts.sys.readFile(f)) : undefined,
  getCurrentDirectory: () => root,
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: ts.sys.fileExists, readFile: ts.sys.readFile,
  readDirectory: ts.sys.readDirectory, directoryExists: ts.sys.directoryExists,
  getDirectories: ts.sys.getDirectories,
  useSourceOfProjectReferenceRedirect: () => true,
  getProjectReferences: () => cfg.projectReferences,
};
const ls = ts.createLanguageService(host);
const f = path.join(root, "web/src/Helper.ts");
const pos = ts.sys.readFile(f).indexOf("square");
const fixes = ls.getCodeFixesAtPosition(f, pos, pos + 6, [2304], {}, { importModuleSpecifierPreference: "non-relative" });
for (const x of fixes) console.log(x.description);
