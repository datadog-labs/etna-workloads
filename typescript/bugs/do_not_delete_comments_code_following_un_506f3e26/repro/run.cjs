const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const text=fs.readFileSync('input.ts','utf8');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'',getCompilationSettings:()=>({}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?text:undefined};
const ls=ts.createLanguageService(host);
const pos=text.indexOf('foo.b ')+5;
const r=ls.getCompletionsAtPosition('input.ts',pos,{});
const e=r.entries.find(x=>x.name==='foo.bar');
console.log(JSON.stringify(e.replacementSpan), JSON.stringify(text.substr(e.replacementSpan.start,e.replacementSpan.length)));
