import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const reg = ts.createDocumentRegistry();
const files = { "/a.ts": "export const a = 1;" };
const host = {
  getCompilationSettings: () => ({ target: 99, noLib: true }),
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host, reg);
const sf1 = ls.getProgram().getSourceFile("/a.ts");
ls.cleanupSemanticCache();
ls.dispose();
const ls2 = ts.createLanguageService(host, reg);
const sf2 = ls2.getProgram().getSourceFile("/a.ts");
console.log("source file reused from registry after dispose:", sf1 === sf2);
