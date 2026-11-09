const ts=require(process.env.TYPESCRIPT);
const fs=require('fs');
const text=fs.readFileSync('input.ts','utf8');
const opts={strict:true};
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'/',getCompilationSettings:()=>opts,getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?text:undefined};
const ls=ts.createLanguageService(host);
const start=text.indexOf('u: {}'),end=start+5;
const fixes=ls.getCodeFixesAtPosition('input.ts',start,end,[2741],{},{});
console.log(fixes.length);
for(const f of fixes){console.log(f.description);for(const c of f.changes)for(const t of c.textChanges)console.log(JSON.stringify(t.newText));}
