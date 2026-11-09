import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
import fs from "fs";
const files = { "/a.js": fs.readFileSync("a.js", "utf8"), "/infer.d.ts": fs.readFileSync("infer.d.ts", "utf8") };
const libPath = ts.getDefaultLibFilePath({});
const libDir = libPath.slice(0, libPath.lastIndexOf("/"));
const realFile = f => f.startsWith("/lib.") ? libDir + f : undefined;
const opts = { allowJs: true, noImplicitThis: true, module: ts.ModuleKind.ESNext, moduleResolution: ts.ModuleResolutionKind.Bundler, noEmit: true, types: [] };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : (realFile(f) && ts.ScriptSnapshot.fromString(fs.readFileSync(realFile(f),"utf8"))),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined || !!realFile(f),
  readFile: f => files[f] ?? (realFile(f) && fs.readFileSync(realFile(f),"utf8")),
};
const ls = ts.createLanguageService(host);
const pos = files["/a.js"].lastIndexOf("this.x") + 5;
const refs = ls.findReferences("/a.js", pos) || [];
for (const r of refs) for (const x of r.references) console.log(x.fileName, x.textSpan.start, x.isWriteAccess);
