import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/repo/src1/dir/test1.ts": 'import * as foo1 from "./',
  "/repo/src2/dir/test2.ts": 'export {}',
  "/repo/src2/dir/f2.ts": 'export {}',
  "/repo/src1/dir/f1.ts": 'export {}',
};
const opts = { rootDirs: ["/repo/src1", "/repo/src2/"] };
const host = {
  getCompilationSettings: () => opts,
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
  readDirectory: (d) => Object.keys(files).filter(f => f.startsWith(d.replace(/\/?$/, "/"))),
  directoryExists: d => Object.keys(files).some(f => f.startsWith(d.replace(/\/?$/, "/"))),
  getDirectories: (d) => { const p = d.replace(/\/?$/, "/"); return [...new Set(Object.keys(files).filter(f => f.startsWith(p)).map(f => f.slice(p.length).split("/")).filter(a => a.length > 1).map(a => a[0]))]; },
};
const ls = ts.createLanguageService(host);
const f = "/repo/src1/dir/test1.ts";
const r = ls.getCompletionsAtPosition(f, files[f].length, {});
process.stdout.write(String(r ? r.entries.map(e => e.name).sort().join(",") : "none")+"\n");
