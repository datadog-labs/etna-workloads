const ts = require(process.env.TYPESCRIPT);
const files = {
  "/a.mts": "export {};",
  "/b.ts": "export {};",
  "/c.ts": "export const c = 0;",
  "/main.ts": 'import {} from "./a.mjs";\nimport {} from "./b";\n\nc;\n',
};
const opts = { module: ts.ModuleKind.ESNext, moduleResolution: ts.ModuleResolutionKind.Bundler };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const pos = files["/main.ts"].lastIndexOf("c");
const fixes = ls.getCodeFixesAtPosition("/main.ts", pos, pos + 1, [2304], {}, {});
for (const f of fixes) console.log(f.description);
