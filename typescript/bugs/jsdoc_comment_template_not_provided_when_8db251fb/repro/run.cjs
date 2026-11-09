const ts = require(process.env.TYPESCRIPT);
const text = `/** @typedef {string} Id */

/** */
function foo(x, y, z) {}
`;
const pos = text.indexOf("/** */") + 3;
const host = {
  getScriptFileNames: () => ["a.js"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.js" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({ allowJs: true }),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "a.js", readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
console.log(JSON.stringify(ls.getDocCommentTemplateAtPosition("a.js", pos), null, 1));
