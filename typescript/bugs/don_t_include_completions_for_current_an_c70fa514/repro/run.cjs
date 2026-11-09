const ts=require(process.env.TYPESCRIPT);
const fs=require('fs');
const text=fs.readFileSync('input.ts','utf8');
const pos=text.indexOf('/*here*/');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>ts.ScriptSnapshot.fromString(text),getCurrentDirectory:()=>'.',getCompilationSettings:()=>({}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:()=>true,readFile:()=>text};
const ls=ts.createLanguageService(host);
const c=ls.getCompletionsAtPosition('input.ts',pos,{});
console.log(c.entries.filter(e=>['a','bb','cc'].includes(e.name)).map(e=>e.name).sort().join(','));
