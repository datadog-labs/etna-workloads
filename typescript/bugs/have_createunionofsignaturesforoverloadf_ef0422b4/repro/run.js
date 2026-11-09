const ts=require(process.env.TYPESCRIPT);
const o={target:ts.ScriptTarget.ES2020,noEmit:true};
const p=ts.createProgram(["input.ts"],o);
const sf=p.getSourceFile("input.ts");
for(const d of [...p.getSemanticDiagnostics(sf),...p.getSuggestionDiagnostics(sf)])
 console.log(d.code,d.category,ts.flattenDiagnosticMessageText(d.messageText,"\n").split("\n")[0]);
