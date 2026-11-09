import { createRequire } from "module";
import path from "path";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const cwd = process.cwd();
const key = f => path.resolve(f).split(path.sep).join("/");
const over = {};
const fileWatchers = new Map();
let timeouts = [];
const sys = {
  ...ts.sys,
  getCurrentDirectory: () => cwd,
  readFile: (f, e) => over[key(f)] ?? ts.sys.readFile(f, e),
  fileExists: f => key(f) in over || ts.sys.fileExists(f),
  watchFile: (f, cb) => { fileWatchers.set(key(f), cb); return { close() { fileWatchers.delete(key(f)); } }; },
  watchDirectory: () => ({ close() {} }),
  setTimeout: cb => { timeouts.push(cb); return timeouts.length; },
  clearTimeout: () => {},
  write: s => process.stdout.write(s.replace(/\r/g, "")),
  clearScreen: () => {},
};
const diag = d => console.log(ts.flattenDiagnosticMessageText(d.messageText, "\n"), d.file ? "@" + path.basename(d.file.fileName) : "");
const host = ts.createWatchCompilerHost("tsconfig.json", { noEmit: true }, sys, ts.createSemanticDiagnosticsBuilderProgram, diag, () => {});
const w = ts.createWatchProgram(host);
const show = t => {
  console.log("== " + t);
  const p = w.getProgram().getProgram();
  for (const f of p.getSourceFiles().filter(f => !f.fileName.includes("lib."))) {
    for (const d of p.getSemanticDiagnostics(f)) console.log(path.basename(f.fileName), d.code, ts.flattenDiagnosticMessageText(d.messageText, "\n"));
    const m = p.getResolvedModule?.(f, "pkg", undefined);
  }
  console.log(p.getSourceFiles().map(f => path.basename(f.fileName)).filter(n => !n.startsWith("lib.")).sort().join(","));
};
show("initial");
const a = key("a.ts");
over[a] = ts.sys.readFile("a.ts") + `\nimport type { ImportInterface } from "pkg" with { "resolution-mode": "import" };\n`;
fileWatchers.get(a)(a, ts.FileWatcherEventKind.Changed);
while (timeouts.length) { const t = timeouts; timeouts = []; t.forEach(f => f()); }
show("after edit");
w.close();
