const ts = require(process.env.TYPESCRIPT);
const path = require("path");
const cwd = process.cwd();
const host = {
  ...ts.sys,
  useCaseSensitiveFileNames: true,
  writeMessage() {}, setImmediate, clearImmediate,
  watchFile: () => ({ close() {} }), watchDirectory: () => ({ close() {} }),
  setTimeout: () => 0, clearTimeout() {},
};
const noop = () => {};
const logger = { close: noop, hasLevel: () => false, loggingEnabled: () => false, perftrace: noop, info: noop, startGroup: noop, endGroup: noop, msg: noop, getLogFileName: () => undefined };
const ps = new ts.server.ProjectService({
  host, logger, cancellationToken: ts.server.nullCancellationToken,
  useSingleInferredProject: true, useInferredProjectPerProjectRoot: false,
  typingsInstaller: ts.server.nullTypingsInstaller, session: undefined,
});
const file = path.join(cwd, "main.ts");
ps.setHostConfiguration({ preferences: { includeCompletionsForModuleExports: true, allowIncompleteCompletions: true } });
ps.openClientFile(file, "", ts.ScriptKind.TS, cwd);
const proj = ps.getDefaultProjectForFile(ts.server.toNormalizedPath(file), true);
const info = proj.getLanguageService().getCompletionsAtPosition(file, 0,
  { includeCompletionsForModuleExports: true, allowIncompleteCompletions: true });
const e = (info?.entries || []).filter(x => x.name === "test");
console.log(JSON.stringify(e.map(x => ({ name: x.name, source: x.source, hasAction: x.hasAction }))));
