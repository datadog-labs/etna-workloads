const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const opts={noImplicitAny:true};
const text=fs.readFileSync('input.ts','utf8');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>opts,getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?text:undefined};
const ls=ts.createLanguageService(host);
const diags=ls.getSemanticDiagnostics('input.ts').concat(ls.getSyntacticDiagnostics('input.ts'));
for(const d of diags){
  if(d.code!==7051)continue;
  const fixes=ls.getCodeFixesAtPosition('input.ts',d.start,d.start+d.length,[d.code],{},{});
  for(const f of fixes){console.log(f.description);for(const c of f.changes)for(const t of c.textChanges)console.log(JSON.stringify(t));}
}
