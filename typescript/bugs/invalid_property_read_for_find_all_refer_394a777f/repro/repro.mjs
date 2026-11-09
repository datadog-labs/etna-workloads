import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files = { "/bar.ts": 'import { Foo } from "./foo";', "/foo.ts": "export { Foo }" };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ module: ts.ModuleKind.CommonJS }),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
try {
  const r = ls.findReferences("/bar.ts", files["/bar.ts"].indexOf("Foo"));
  console.log(JSON.stringify((r||[]).map(x => x.references.map(y => [y.fileName, y.textSpan]))));
} catch (e) { console.log("threw", e instanceof TypeError); }
