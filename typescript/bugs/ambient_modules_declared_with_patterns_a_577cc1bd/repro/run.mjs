import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files = {
  "/globals.d.ts": `declare module "*.css";\ndeclare module "plain-mod";\n`,
  "/a.ts": `import * as foo from "";\n`,
};
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const pos = files["/a.ts"].indexOf('""') + 1;
const r = ls.getCompletionsAtPosition("/a.ts", pos, {});
console.log((r?.entries ?? []).map(e => e.name).sort().join("\n"));
