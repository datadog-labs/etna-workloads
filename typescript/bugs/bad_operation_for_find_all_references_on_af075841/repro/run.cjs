const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const text=fs.readFileSync('input.ts','utf8');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({module:ts.ModuleKind.ESNext,target:ts.ScriptTarget.ESNext}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:()=>false,readFile:()=>undefined};
const ls=ts.createLanguageService(host);
try{const r=ls.findReferences('input.ts',text.indexOf('import.meta')+7);console.log(JSON.stringify(r&&r.map(x=>x.references.map(y=>y.textSpan))));}catch(e){console.log('error',e.message.split('\n')[0])}
