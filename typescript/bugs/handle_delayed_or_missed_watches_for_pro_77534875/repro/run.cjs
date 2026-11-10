const ts = require(process.env.TYPESCRIPT);
const files = new Map([
  ["/p/tsconfig.json", '{"compilerOptions":{"noLib":true,"types":[]}}'],
  ["/p/b.ts", "export const b = 1;"],
]);
const dirs = new Set(["/p"]);
const base = ts.sys; const MT = { getTime: () => 0, valueOf: () => 0 };
const dirWatchers = []; const timeouts = [];
const sys = {
  ...base,
  useCaseSensitiveFileNames: true,
  getCurrentDirectory: () => "/p",
  fileExists: f => files.has(f),
  directoryExists: d => dirs.has(d),
  readFile: f => files.get(f),
  getModifiedTime: f => files.has(f) ? MT : undefined,
  realpath: p => p,
  writeFile() {},
  readDirectory(path, exts, excl, incl, depth) {
    return ts.matchFiles(path, exts, excl, incl, true, "/p", depth, d => {
      const pre = d.endsWith("/") ? d : d + "/";
      return {
        files: [...files.keys()].filter(f => f.startsWith(pre) && !f.slice(pre.length).includes("/")).map(f => f.slice(pre.length)),
        directories: [...dirs].filter(x => x.startsWith(pre) && !x.slice(pre.length).includes("/")).map(x => x.slice(pre.length)),
      };
    }, p => p, d => dirs.has(d));
  },
  getDirectories: d => [...dirs].filter(x => x.startsWith(d + "/") && !x.slice(d.length + 1).includes("/")),
  watchFile: () => ({ close() {} }),
  watchDirectory(dir, cb, recursive) { dirWatchers.push({ dir, cb, recursive }); return { close() {} }; },
  setTimeout: (cb) => { timeouts.push(cb); return timeouts.length; },
  clearTimeout() {},
};
const host = ts.createWatchCompilerHost("/p/tsconfig.json", {}, sys, ts.createSemanticDiagnosticsBuilderProgram, () => {}, () => {});
const w = ts.createWatchProgram(host);
const show = l => console.log(l, w.getProgram().getSourceFiles().map(f => f.fileName).join(","));
show("initial:");
dirs.add("/p/sub"); files.set("/p/sub/a.ts", "export const a = 1;");
for (const x of dirWatchers.filter(x => "/p".startsWith(x.dir))) x.cb("/p/sub/a.ts");
while (timeouts.length) timeouts.shift()();
show("after:");
