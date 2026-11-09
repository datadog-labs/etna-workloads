import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files = ["modules.ts", "app.ts"];
const host = {
  getScriptFileNames: () => files,
  getScriptVersion: () => "1",
  getScriptSnapshot: f => fs.existsSync(f) ? ts.ScriptSnapshot.fromString(fs.readFileSync(f, "utf8")) : undefined,
  getCurrentDirectory: () => process.cwd(),
  getCompilationSettings: () => ({ strict: true, module: ts.ModuleKind.ESNext, moduleResolution: ts.ModuleResolutionKind.Bundler, noLib: true }),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => fs.existsSync(f),
  readFile: f => fs.readFileSync(f, "utf8"),
};
const ls = ts.createLanguageService(host);
const pos = fs.readFileSync("app.ts", "utf8").indexOf("someEnv.charAt");
const qi = ls.getQuickInfoAtPosition("app.ts", pos + 2);
console.log(ts.displayPartsToString(qi.displayParts));
