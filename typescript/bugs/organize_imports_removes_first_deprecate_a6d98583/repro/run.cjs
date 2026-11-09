const ts = require(process.env.TYPESCRIPT);
const files = {
  "/a.ts": "export interface L {}\nexport interface P {}\n",
  "/b.ts": "export {\n    /** @deprecated Use L instead */\n    L as A,\n    L,\n    /** @deprecated Use P instead */\n    P as N,\n    P,\n} from './a';\n",
};
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const ch = ls.organizeImports({ type: "file", fileName: "/b.ts" }, {}, {});
for (const c of ch) { let t = files[c.fileName]; for (const x of [...c.textChanges].reverse()) t = t.slice(0, x.span.start) + x.newText + t.slice(x.span.start + x.span.length); console.log(t); }
