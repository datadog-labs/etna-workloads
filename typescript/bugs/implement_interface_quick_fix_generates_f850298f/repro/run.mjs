import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/a.ts": "class Foo implements Disposable {}",
  "/g.d.ts": "interface SymbolConstructor { readonly dispose: unique symbol; }\ninterface Disposable { [Symbol.dispose](): void; }\n",
};
const opts = { target: ts.ScriptTarget.ESNext, lib: ["lib.esnext.d.ts"] };
const host = {
  getCompilationSettings: () => opts,
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => { const t = files[f] ?? ts.sys.readFile(f); return t === undefined ? undefined : ts.ScriptSnapshot.fromString(t); },
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f in files || ts.sys.fileExists(f),
  readFile: f => files[f] ?? ts.sys.readFile(f),
  directoryExists: ts.sys.directoryExists,
  getDirectories: ts.sys.getDirectories,
};
const ls = ts.createLanguageService(host);
const pos = files["/a.ts"].indexOf("Foo");
const fixes = ls.getCodeFixesAtPosition("/a.ts", pos, pos + 3, [2420], {}, {});
for (const f of fixes) { console.log(f.description); for (const c of f.changes) for (const t of c.textChanges) console.log(JSON.stringify(t.newText)); }
