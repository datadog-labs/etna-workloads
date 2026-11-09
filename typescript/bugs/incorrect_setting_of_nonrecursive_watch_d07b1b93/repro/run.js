const ts = require(process.env.TYPESCRIPT);
const root = "/home/user/proj";
const files = { [root + "/input.ts"]: 'import "./missing"; export {};' };
const sys = {
  ...ts.sys,
  getCurrentDirectory: () => root,
  fileExists: f => f in files,
  readFile: f => files[f],
  directoryExists: d => d === root || d === "/home/user" || d === "/home" || d === "/",
  getDirectories: () => [],
  readDirectory: () => [root + "/input.ts"],
  realpath: p => p,
  preferNonRecursiveWatch: true,
  watchFile: () => ({ close() {} }),
  watchDirectory: (d, cb, rec) => { console.log("watchDir", d.replace(root, "<root>"), "recursive=" + !!rec); return { close() {} }; },
  setTimeout: () => 0, clearTimeout() {},
  write() {}, clearScreen() {},
};
const host = ts.createWatchCompilerHost([root + "/input.ts"], { noEmit: true, noLib: true, types: [] }, sys, undefined,
  d => console.log("diag", d.code), () => {});
try { ts.createWatchProgram(host).close(); } catch (e) { console.log("threw", String(e.message).split("\n")[0]); }
