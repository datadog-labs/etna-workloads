const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const files = { "/p/a.ts": fs.readFileSync("a.ts","utf8"), "/p/folder/target.ts": "" };
const host = {
  getCompilationSettings: () => ({ lib: ["lib.es5.d.ts"] }),
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/p",
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host, ts.createDocumentRegistry());
function mkHost(files, ver) {
  return {
    getCompilationSettings: () => ({ lib: ["lib.es5.d.ts"] }),
    getScriptFileNames: () => Object.keys(files),
    getScriptVersion: () => ver,
    getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
    getCurrentDirectory: () => "/p",
    getDefaultLibFileName: () => "lib.d.ts",
    fileExists: f => files[f] !== undefined,
    readFile: f => files[f],
  };
}
host.runWithTemporaryFileUpdate = (f, text, cb) => {
  const op = ls.getProgram();
  const up = ts.createLanguageService(mkHost({ ...files, [f]: text }, "2"), ts.createDocumentRegistry()).getProgram();
  cb(up, op, up.getSourceFile(f));
};
const a = files["/p/a.ts"];
const pos = a.indexOf("foo()", a.indexOf("\n\n"));
const r = ls.getPasteEdits({
  targetFile: "/p/folder/target.ts",
  pastedText: ["foo()"],
  pasteLocations: [{pos:0,end:0}],
  copiedFrom: { file: "/p/a.ts", range: [{pos, end: pos+5}] },
  preferences: {},
}, ts.getDefaultFormatCodeSettings());
console.log(JSON.stringify(r, null, 1));
