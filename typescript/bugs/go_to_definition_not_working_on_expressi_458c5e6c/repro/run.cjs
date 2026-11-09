const ts=require(process.env.TYPESCRIPT);
const text=require('fs').readFileSync('input.ts','utf8');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?text:undefined};
const ls=ts.createLanguageService(host);
const pos=text.indexOf('title');
const d=ls.getDefinitionAtPosition('input.ts',pos)||[];
console.log(JSON.stringify(d.map(x=>[x.name,x.textSpan])));
