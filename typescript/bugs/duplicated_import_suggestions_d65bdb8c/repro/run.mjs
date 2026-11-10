import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files = {
  "/repo/src1/dir/a.ts": "export {}",
  "/repo/src2/dir/b.ts": "export {}",
  "/repo/src2/index.ts": 'import * as x from "./',
};
const opts = { rootDirs: ["/repo/src1", "/repo/src2"] };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/repo",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
  readDirectory: (d, exts) => Object.keys(files).filter(f => f.startsWith(d.replace(/\/$/, "") + "/")),
  directoryExists: d => Object.keys(files).some(f => f.startsWith(d.replace(/\/$/, "") + "/")),
  getDirectories: d => { const p = d.replace(/\/$/, "") + "/"; return [...new Set(Object.keys(files).filter(f => f.startsWith(p)).map(f => f.slice(p.length).split("/")).filter(a => a.length > 1).map(a => a[0]))]; },
  useCaseSensitiveFileNames: () => true,
};
const ls = ts.createLanguageService(host);
const f = "/repo/src2/index.ts";
const r = ls.getCompletionsAtPosition(f, files[f].length, {});
console.log(r.entries.map(e => e.name + ":" + e.kind).join("\n"));
