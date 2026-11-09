const ts = require(process.env.TYPESCRIPT);
const src = `/**
 * @param {Object} options the args object
 * @param {number} options.a first number
 * @param {number} options.b second number
 * @returns {number}
 */
function f(options) {}
f;
`;
const host = {
  getScriptFileNames: () => ["a.js"], getScriptVersion: () => "1",
  getScriptSnapshot: n => n === "a.js" ? ts.ScriptSnapshot.fromString(src) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({ allowJs: true }),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: n => n === "a.js", readFile: n => n === "a.js" ? src : undefined,
};
const ls = ts.createLanguageService(host);
const qi = ls.getQuickInfoAtPosition("a.js", src.lastIndexOf("f;"));
console.log(JSON.stringify(qi.tags));
