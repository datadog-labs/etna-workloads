const ts = require(process.env.TYPESCRIPT);
const text = 'declare function f(x: string, y: number): any;\nf();\n';
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: n => n === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({ strict: true, noLib: true }),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: n => n === "a.ts", readFile: n => n === "a.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("f();") + 2;
const sh = ls.getSignatureHelpItems("a.ts", pos, { triggerReason: { kind: "invoked" } });
console.log("sighelp items:", sh && sh.items.length);
for (const d of ls.getSemanticDiagnostics("a.ts")) console.log(d.start, ts.flattenDiagnosticMessageText(d.messageText, "\n"));
