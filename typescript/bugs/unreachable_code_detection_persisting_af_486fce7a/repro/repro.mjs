import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const orig = `import { a } from './a';
export class C {
    async f(d: string): Promise<string> {
        return d;
    }
}
`;
const files = { "/a.ts": "export const a = 1;", "/w.ts": orig };
let ver = 0;
const host = {
  getCompilationSettings: () => ({ allowUnreachableCode: false, lib: ["lib.es2015.d.ts"], target: 2 }),
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => String(ver),
  getScriptSnapshot: f => files[f] !== undefined ? snap(f) : (ts.sys.fileExists(f) ? ts.ScriptSnapshot.fromString(ts.sys.readFile(f)) : undefined),
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => files[f] !== undefined || ts.sys.fileExists(f),
  readFile: f => files[f] ?? ts.sys.readFile(f),
};
const snaps = {};
function snap(f) {
  const text = files[f];
  if (snaps[f] && snaps[f].text === text) return snaps[f].s;
  const s = ts.ScriptSnapshot.fromString(text);
  const old = snaps[f];
  s.getChangeRange = prev => {
    if (!old || prev !== old.s) return undefined;
    let a = 0; const ot = old.text;
    while (a < ot.length && a < text.length && ot[a] === text[a]) a++;
    let b = 0;
    while (b < ot.length - a && b < text.length - a && ot[ot.length-1-b] === text[text.length-1-b]) b++;
    return ts.createTextChangeRange(ts.createTextSpan(a, ot.length - a - b), text.length - a - b);
  };
  snaps[f] = { text, s };
  return s;
}
const ls = ts.createLanguageService(host);
const show = l => console.log(l, ls.getSyntacticDiagnostics("/w.ts").length, ls.getSemanticDiagnostics("/w.ts").map(d => d.code));
show("initial");
files["/w.ts"] = "throw new Error('foo');\n" + orig; ver++;
show("after insert");
files["/w.ts"] = orig; ver++;
show("after delete");
