import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const p = ts.createProgram(["input.ts"], { strict: true, noEmit: true, target: ts.ScriptTarget.ES2015 });
const sf = p.getSourceFile("input.ts");
try {
for (const d of [...p.getSyntacticDiagnostics(sf), ...p.getSemanticDiagnostics(sf)]) {
  console.log(d.code, d.start, d.length, ts.flattenDiagnosticMessageText(d.messageText, "\n"));
  for (const r of d.relatedInformation || []) console.log("  related", r.code, r.start, r.length, ts.flattenDiagnosticMessageText(r.messageText, "\n"));
}
} catch (e) { console.log("crash:", String(e.message).split("\n")[0]); }
