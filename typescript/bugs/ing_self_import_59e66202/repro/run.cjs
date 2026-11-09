const ts = require(process.env.TYPESCRIPT);
const text = "const k = 1;\nconsole.log(k);\n\n\nconsole.log(\"test\");\n";
let ver = 1;
const files = { "/p/target.ts": text };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => String(ver),
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/p",
  getCompilationSettings: () => ({ lib: ["lib.es5.d.ts"], noLib: true }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
  runWithTemporaryFileUpdate(fileName, newText, cb) {
    const orig = files[fileName], origProgram = ls.getProgram();
    files[fileName] = newText; ver++;
    try {
      const prog = ls.getProgram();
      cb(prog, origProgram, prog.getSourceFile(fileName));
    } finally { files[fileName] = orig; ver++; }
  },
};
const ls = ts.createLanguageService(host);
const s = text.indexOf("console.log(k);");
const r = ls.getPasteEdits({
  targetFile: "/p/target.ts",
  pastedText: ["console.log(k);"],
  pasteLocations: [{ pos: text.indexOf("\n\n\n") + 2, end: text.indexOf("\n\n\n") + 2 }],
  copiedFrom: { file: "/p/target.ts", range: [{ pos: s, end: s + 15 }] },
  preferences: {},
  formatOptions: {},
}, {});
console.log(JSON.stringify(r, null, 1));
