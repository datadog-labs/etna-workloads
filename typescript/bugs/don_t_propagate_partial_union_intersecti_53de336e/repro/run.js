const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
let text = fs.readFileSync("input.ts", "utf8");
let rev = 0;
const opts = { strict: true, lib: ["lib.esnext.d.ts"], noEmit: true };
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => String(rev),
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) :
    (fs.existsSync(f) ? ts.ScriptSnapshot.fromString(fs.readFileSync(f, "utf8")) : undefined),
  getCurrentDirectory: () => process.cwd(),
  getCompilationSettings: () => opts,
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: ts.sys.fileExists, readFile: ts.sys.readFile,
  readDirectory: ts.sys.readDirectory, directoryExists: ts.sys.directoryExists,
};
const ls = ts.createLanguageService(host);
const show = l => { const d = ls.getSemanticDiagnostics("input.ts");
  console.log(l, d.length); d.forEach(x => console.log(ts.flattenDiagnosticMessageText(x.messageText, "\n"))); };
show("before edit:");
text = text.replace("//MARK", "type C = Component['name']");
rev++;
show("after edit:");
