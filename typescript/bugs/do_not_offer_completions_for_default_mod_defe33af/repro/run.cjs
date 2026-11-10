const ts=require(process.env.TYPESCRIPT);
const src=require('fs').readFileSync('input.ts','utf8');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(src):undefined,getCurrentDirectory:()=>'/',getCompilationSettings:()=>({}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?src:undefined};
const ls=ts.createLanguageService(host);
const r=ls.getCompletionsAtPosition('input.ts',src.length-1,{});
console.log(r.entries.filter(e=>e.name==='default').map(e=>e.name+' '+e.kind));
