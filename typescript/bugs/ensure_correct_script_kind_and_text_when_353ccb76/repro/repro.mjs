import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const path = require("path");
const root = process.cwd();
const x = path.join(root, "x.ts");

// A plugin that decides the script kind of x.ts (TS first, TSX later).
let kind = ts.ScriptKind.TS;
const plugin = {
  create(info) {
    const host = info.languageServiceHost;
    const orig = host.getScriptKind && host.getScriptKind.bind(host);
    host.getScriptKind = (f) => (f.endsWith("/x.ts") ? kind : orig ? orig(f) : ts.ScriptKind.Unknown);
    return info.languageService;
  },
};
const host = {
  ...ts.sys,
  watchFile: () => ({ close() {} }),
  watchDirectory: () => ({ close() {} }),
  setTimeout: () => 0, clearTimeout() {},
  setImmediate: () => 0, clearImmediate() {},
  require: () => ({ module: () => plugin, error: undefined }),
};
const logger = { close() {}, hasLevel: () => false, loggingEnabled: () => false, perftrc() {}, info() {}, startGroup() {}, endGroup() {}, msg() {}, getLogFileName: () => undefined };
const ps = new ts.server.ProjectService({
  host, logger, cancellationToken: ts.server.nullCancellationToken,
  useSingleInferredProject: false, useInferredProjectPerProjectRoot: true,
  typingsInstaller: ts.server.nullTypingsInstaller, session: undefined,
  globalPlugins: ["kind-plugin"], pluginProbeLocations: [root], allowLocalPluginLoads: true,
});
ps.setCompilerOptionsForInferredProjects({ noLib: true, jsx: ts.JsxEmit.Preserve });
function show(label, file) {
  const proj = ps.getDefaultProjectForFile(ts.server.toNormalizedPath(file), true);
  const ls = proj.getLanguageService();
  const diags = ls.getSyntacticDiagnostics(x).concat(ls.getSemanticDiagnostics(x));
  console.log(label, "x.ts kind:", ts.ScriptKind[proj.getSourceFile(proj.toPath(x)).scriptKind],
    diags.map(d => ts.flattenDiagnosticMessageText(d.messageText, "\n")));
}
ps.openClientFile(path.join(root, "H", "h.ts"));
const y1 = path.join(root, "A", "y1.ts");
ps.openClientFile(y1, undefined, undefined, path.join(root, "A"));
show("A", y1);
ps.openClientFile(y1, "export {};", undefined, path.join(root, "A"));
ps.getDefaultProjectForFile(ts.server.toNormalizedPath(y1), true).getLanguageService().getProgram();
kind = ts.ScriptKind.TSX;
const y2 = path.join(root, "D", "y.ts");
ps.openClientFile(y2, undefined, undefined, path.join(root, "D"));
show("D", y2);
