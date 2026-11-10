import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = `/** {@link nonexistent} */
export function f() {}
const x = 1;
/** see {@link x.y} */
export const z = 2;
`;
const files = { "a.ts": text };
const host = {
  getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: n => files[n] !== undefined ? ts.ScriptSnapshot.fromString(files[n]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: n => n in files, readFile: n => files[n],
};
const ls = ts.createLanguageService(host);
for (const p of [text.indexOf("nonexistent"), text.indexOf("x.y"), text.indexOf("y}")]) {
  const d = ls.getDefinitionAtPosition("a.ts", p);
  console.log(p, d ? d.length : d);
}
for (const d of ls.getSemanticDiagnostics("a.ts")) console.log("sem", d.code, ts.flattenDiagnosticMessageText(d.messageText, "\n"));
