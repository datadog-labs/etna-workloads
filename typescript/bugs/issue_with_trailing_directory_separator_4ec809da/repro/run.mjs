import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const root = process.cwd() + "/app";
const host = { ...ts.sys, setTimeout: (f) => 0, clearTimeout: () => {}, setImmediate: () => 0, clearImmediate: () => {}, watchFile: () => ({ close() {} }), watchDirectory: () => ({ close() {} }) };
const logger = { close() {}, hasLevel: () => false, loggingEnabled: () => false, perftrc() {}, info() {}, startGroup() {}, endGroup() {}, msg() {}, getLogFileName: () => undefined };
const svc = new ts.server.ProjectService({
  host, logger, cancellationToken: ts.server.nullCancellationToken, useSingleInferredProject: false, useInferredProjectPerProjectRoot: false,
  typingsInstaller: ts.server.nullTypingsInstaller, session: undefined,
});
const a = root + "/src/a.ts", b = root + "/src/b.ts", c = root + "/src/c.ts";
svc.openClientFile(a, ts.sys.readFile(a), ts.ScriptKind.TS, root);
svc.openClientFile(b, ts.sys.readFile(b), ts.ScriptKind.TS, root);
svc.openClientFile(c, ts.sys.readFile(c), ts.ScriptKind.TS, root);
const show = () => {
  const p = svc.getDefaultProjectForFile(ts.server.toNormalizedPath(b), true);
  console.log(p.getProjectName().replace(process.cwd(), "."));
  for (const d of p.getLanguageService().getSemanticDiagnostics(b))
    console.log(d.start, ts.flattenDiagnosticMessageText(d.messageText, "\n"));
};
show();
svc.applyChangesInOpenFiles(undefined, [{ fileName: b, changes: [{ span: { start: 0, length: 0 }, newText: "import { make as m2 } from \"lib/dist/index\";\nexport const z: string = m2();\n" }] }]);
show();
