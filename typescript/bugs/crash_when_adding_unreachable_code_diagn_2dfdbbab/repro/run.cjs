const ts = require(process.env.TYPESCRIPT);
const p = ts.createProgram(["input.ts"], {strict:true,target:ts.ScriptTarget.ESNext,noEmit:true,allowUnreachableCode:false});
const sf = p.getSourceFile("input.ts");
for (const d of [...p.getSyntacticDiagnostics(sf), ...p.getSemanticDiagnostics(sf)])
  console.log(d.start, d.length, ts.flattenDiagnosticMessageText(d.messageText,"\n"));
