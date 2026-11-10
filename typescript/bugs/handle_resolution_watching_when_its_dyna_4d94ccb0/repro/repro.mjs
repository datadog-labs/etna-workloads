import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const cwd = "/proj";
const files = { [cwd + "/a.ts"]: "export const a = 1;\n", [cwd + "/types/foo/index.d.ts"]: "declare const foo: number;\n" };
const dirs = new Set(["/"]);
for (const f of Object.keys(files)) { let d = f; while ((d = d.slice(0, d.lastIndexOf("/"))) ) dirs.add(d); }
const sys = {
  ...ts.sys,
  getCurrentDirectory: () => cwd,
  fileExists: f => f in files,
  readFile: f => files[f],
  directoryExists: d => dirs.has(d),
  getDirectories: d => [...dirs].filter(x => x.startsWith(d === "/" ? "/" : d + "/") && x !== d && !x.slice(d.length + 1).includes("/")).map(x => x.slice(d.length + 1)),
  readDirectory: () => [],
  watchFile: (f) => { console.log("watchFile", f); return { close() {} }; },
  watchDirectory: (d, cb, rec) => { console.log("watchDirectory", d, !!rec); return { close() {} }; },
  setTimeout: () => 0, clearTimeout() {}, write() {},
  getExecutingFilePath: () => "/tsc.js",
  realpath: p => p,
};
const host = ts.createWatchCompilerHost([cwd + "/a.ts"], { noEmit: true, types: ["*"], typeRoots: [cwd + "/types"] }, sys, ts.createSemanticDiagnosticsBuilderProgram, () => {}, () => {});
ts.createWatchProgram(host);
