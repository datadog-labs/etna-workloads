const ts = require(process.env.TYPESCRIPT);
const files = { "/proj/src/one.ts": "export const one = 1;", "/proj/src/foo/two.ts": "one" };
const options = { paths: { "@root/*": ["/proj/src/*"] }, module: ts.ModuleKind.ESNext, moduleResolution: ts.ModuleResolutionKind.Bundler };
const host = {
  getCompilationSettings: () => options,
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/proj",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const fixes = ls.getCodeFixesAtPosition("/proj/src/foo/two.ts", 0, 3, [2304], {}, { allowIncompleteCompletions: true });
for (const f of fixes) console.log(f.description);
