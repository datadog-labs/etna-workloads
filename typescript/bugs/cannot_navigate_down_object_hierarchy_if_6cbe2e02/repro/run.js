const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const text=fs.readFileSync('input.ts','utf8');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f=='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f=='input.ts',readFile:f=>f=='input.ts'?text:undefined};
const ls=ts.createLanguageService(host);
const r=ls.getImplementationAtPosition('input.ts',text.indexOf('A {')+0)||[];
for(const x of r)console.log(text.slice(x.textSpan.start,x.textSpan.start+x.textSpan.length));
