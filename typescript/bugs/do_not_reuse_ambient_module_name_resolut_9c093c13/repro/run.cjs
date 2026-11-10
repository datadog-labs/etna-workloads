const ts = require(process.env.TYPESCRIPT);
const files = {
  "/p/app.ts": "import * as fs from 'fs';\n",
  "/p/node.d.ts": "declare module 'fs' {}\n",
};
const opts = { target: ts.ScriptTarget.ES2015, noLib: true, types: [], traceResolution: true };
const traces=[]; const cache={};
function mk() {
  return { trace: s => traces.push(s),
    getSourceFile: (n, l) => { if (files[n] === undefined) return undefined; const c = cache[n]; if (c && c.text === files[n]) return c; return cache[n] = ts.createSourceFile(n, files[n], l); },
    getDefaultLibFileName: () => "/lib.d.ts",
    writeFile() {}, getCurrentDirectory: () => "/p", getDirectories: () => [],
    fileExists: n => files[n] !== undefined, readFile: n => files[n],
    getCanonicalFileName: n => n, useCaseSensitiveFileNames: () => true, getNewLine: () => "\n",
  };
}
const roots = ["/p/app.ts", "/p/node.d.ts"];
const show = (p) => { console.log(ts.getPreEmitDiagnostics(p).filter(d=>d.code!==2318).map(d => d.code+" "+ts.flattenDiagnosticMessageText(d.messageText, "\n")).join("\n") || "(no errors)"); console.log(traces.filter(t=>/^(Module|=====)/.test(t)).join("\n")); traces.length=0; };
let p1 = ts.createProgram(roots, opts, mk());
show(p1);
files["/p/app.ts"] = "import * as fs from 'fs';\nvar x = 1;\n";
let p2 = ts.createProgram(roots, opts, mk(), p1);
show(p2);
files["/p/app.ts"] = "import * as fs from 'fs';\nvar y = 1;\n";
files["/p/node.d.ts"] = "declare var process: any;\n";
let p3 = ts.createProgram(roots, opts, mk(), p2);
show(p3);
