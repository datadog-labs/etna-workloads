const ts = require(process.env.TYPESCRIPT);
const files = {
  "/node_modules/dottie/package.json": '{"name":"dottie","main":"dottie.js"}',
  "/node_modules/dottie/dottie.js": `(function (undefined) {
  var root = this;
  var Dottie = function () {};
  Dottie["default"] = function (object, path, value) {};
  if (typeof module !== "undefined" && module.exports) {
    exports = module.exports = Dottie;
  } else {
    root["Dottie"] = Dottie;
    root["Dot"] = Dottie;
  }
})();
`,
  "/src/index.js": "",
};
const opts = { allowJs: true, checkJs: true, moduleResolution: ts.ModuleResolutionKind.Bundler, module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ESNext, noEmit: true };
const host = {
  getScriptFileNames: () => Object.keys(files).filter(f => /\.js$/.test(f)),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
  directoryExists: d => Object.keys(files).some(f => f.startsWith(d.replace(/\/$/, "") + "/")),
  getDirectories: () => [],
  useCaseSensitiveFileNames: () => true,
};
const ls = ts.createLanguageService(host);
try {
  const r = ls.getCompletionsAtPosition("/src/index.js", 0, { includeCompletionsForModuleExports: true });
  console.log(JSON.stringify((r?.entries || []).filter(e => e.source === "dottie").map(e => [e.name, e.source, e.hasAction])));
} catch (e) { console.log("crash:", e.message.split("\n")[0]); }
