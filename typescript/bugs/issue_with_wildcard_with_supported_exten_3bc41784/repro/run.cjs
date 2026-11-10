const ts = require(process.env.TYPESCRIPT);
const fs = require("fs"), path = require("path");
const cwd = process.cwd().replace(/\\/g, "/");
const dirWatchers = [];
const host = {
  ...ts.sys,
  watchDirectory(dir, cb, rec, opts) { dirWatchers.push({ dir, cb }); return { close() {} }; },
  watchFile() { return { close() {} }; },
  setTimeout: (f, d, ...a) => { pending.push(() => f(...a)); return pending.length; },
  clearTimeout() {},
  setImmediate: (f) => f(),
  clearImmediate() {},
  require(dir, name) {
    return { module: (mod) => ({ create(info) {
      const h = info.languageServiceHost;
      h.getExternalFiles = () => fs.readdirSync(cwd).filter(f => f.endsWith(".vue")).map(f => cwd + "/" + f);
      h.getScriptKind = (f) => f.endsWith(".vue") ? ts.ScriptKind.TS : undefined;
      return info.languageService;
    }}), error: undefined };
  },
};
const pending = [];
const svc = new ts.server.ProjectService({
  host, logger: ts.server.nullLogger ?? { close(){}, hasLevel:()=>false, loggingEnabled:()=>false, perftrc(){}, info(){}, startGroup(){}, endGroup(){}, msg(){}, getLogFileName(){} },
  cancellationToken: ts.server.nullCancellationToken, useSingleInferredProject: false, useInferredProjectPerProjectRoot: false,
  session: undefined, globalPlugins: ["p"], pluginProbeLocations: ["/x"], allowLocalPluginLoads: true,
});
svc.openClientFile(cwd + "/a.ts");
const proj = () => [...svc.configuredProjects.values()][0];
const files = () => proj().getFileNames().map(f => path.basename(f)).sort().filter(f => !f.startsWith("lib."));
console.log("initial:", files().join(","));
fs.writeFileSync("c.vue", 'export const y = "c";');
for (const w of dirWatchers) if (cwd.startsWith(w.dir) || w.dir.startsWith(cwd)) w.cb(cwd + "/c.vue");
console.log("project scheduled for reload:", pending.length > 0);
pending.splice(0).forEach(f => f());
console.log("after:", files().join(","));
