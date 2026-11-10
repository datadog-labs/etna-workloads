const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const text=fs.readFileSync('input.ts','utf8');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?text:undefined};
const ls=ts.createLanguageService(host);
const pos=text.indexOf('>;')+1;
const r=ls.getApplicableRefactors('input.ts',{pos,end:pos},{},'invoked');
console.log(JSON.stringify(r.map(x=>[x.name,x.actions.map(a=>a.name)])));
