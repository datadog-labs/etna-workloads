import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = `function foo(): number;
function foo(x: number, y: number): number;
function foo(x?: number, y?: number): number {
    return 1234;
}

export {}
`;
const opts = { noUnusedLocals: true, strict: true };
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "a.ts", readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
const diags = ls.getSemanticDiagnostics("a.ts");
for (const d of diags) {
  const fixes = ls.getCodeFixesAtPosition("a.ts", d.start, d.start + d.length, [d.code], {}, {});
  for (const f of fixes) {
    console.log(f.description);
    for (const c of f.changes) for (const t of c.textChanges) console.log(JSON.stringify(t));
  }
}
