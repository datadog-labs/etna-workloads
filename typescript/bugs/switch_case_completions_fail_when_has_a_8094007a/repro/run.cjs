const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const text=fs.readFileSync('input.ts','utf8');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({strict:true}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?text:undefined};
const ls=ts.createLanguageService(host);
const pos=text.indexOf('{\n        \n')+10;
const r=ls.getCompletionsAtPosition('input.ts',pos,{includeCompletionsWithInsertText:true});
for(const e of r.entries.filter(e=>e.source==='SwitchCases/'||e.name.startsWith('case')))console.log(e.name,JSON.stringify(e.insertText));
