const ts = require(process.env.TYPESCRIPT);
const p = ts.createProgram(["input.ts"], { erasableSyntaxOnly: true, noEmit: true });
for (const d of ts.getPreEmitDiagnostics(p)) {
  console.log(d.code, d.start, d.length, JSON.stringify(d.file.text.substr(d.start, d.length)));
}
