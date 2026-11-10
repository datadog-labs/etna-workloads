const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const text=fs.readFileSync('a.ts','utf8');
const host={getScriptFileNames:()=>['a.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='a.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='a.ts',readFile:f=>f==='a.ts'?text:undefined};
const ls=ts.createLanguageService(host);
const d=ls.getSuggestionDiagnostics('a.ts').concat(ls.getSemanticDiagnostics('a.ts'));
for(const x of d){
 const fixes=ls.getCodeFixesAtPosition('a.ts',x.start,x.start+x.length,[x.code],{},{});
 fixes.forEach(f=>{console.log(f.description);for(const c of f.changes)for(const t of c.textChanges){console.log(JSON.stringify(t))}});
}
