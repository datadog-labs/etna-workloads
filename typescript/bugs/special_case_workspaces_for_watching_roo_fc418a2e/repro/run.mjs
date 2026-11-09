import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/workspaces/proj/a.ts": 'import "foo";\nexport {};',
  "/workspaces/proj/tsconfig.json": '{"compilerOptions":{"module":"commonjs","moduleResolution":"node10"},"files":["a.ts"]}',
};
const dirs = new Set(["/", "/workspaces", "/workspaces/proj"]);
const log = [];
const sys = {
  ...ts.sys,
  useCaseSensitiveFileNames: true,
  getCurrentDirectory: () => "/workspaces/proj",
  fileExists: f => f in files,
  readFile: f => files[f],
  directoryExists: d => dirs.has(d),
  getDirectories: () => [],
  readDirectory: () => Object.keys(files),
  realpath: p => p,
  writeFile() {}, 
  watchFile: (f) => { log.push("file " + f); return { close() {} }; },
  watchDirectory: (d, cb, rec) => { log.push("dir " + d + " " + rec); return { close() {} }; },
  setTimeout: () => 0, clearTimeout() {},
};
const host = ts.createWatchCompilerHost("/workspaces/proj/tsconfig.json", {noEmit:true}, sys, ts.createSemanticDiagnosticsBuilderProgram, () => {}, () => {});
ts.createWatchProgram(host);
console.log(log.sort().join("\n"));
