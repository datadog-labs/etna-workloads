const ts = require(process.env.TYPESCRIPT);
const src = `/** @typedef {number} https://wat */

/** {@link https://hva} */
var see = true;
see;
`;
const host = ts.createCompilerHost({});
const opts = { allowJs: true, checkJs: true, noEmit: true };
host.getSourceFile = (n, l) => n === "a.js" ? ts.createSourceFile(n, src, l, true) : undefined;
host.fileExists = n => n === "a.js"; host.readFile = n => n === "a.js" ? src : undefined;
host.getDefaultLibFileName = () => "lib.d.ts";
const svc = ts.createLanguageService({
  getCompilationSettings: () => opts, getScriptFileNames: () => ["a.js"],
  getScriptVersion: () => "1", getScriptSnapshot: n => n === "a.js" ? ts.ScriptSnapshot.fromString(src) : undefined,
  getCurrentDirectory: () => "/", getDefaultLibFileName: () => "lib.d.ts",
  fileExists: n => n === "a.js", readFile: n => n === "a.js" ? src : undefined,
});
const qi = svc.getQuickInfoAtPosition("a.js", src.indexOf("see =") + 1);
console.log(JSON.stringify(qi.documentation));
