const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const t=fs.readFileSync('input.ts','utf8');
const opts={target:ts.ScriptTarget.ESNext,lib:['lib.esnext.d.ts']};
const h=ts.createCompilerHost(opts);
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(t):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>opts,getDefaultLibFileName:()=>'lib.d.ts',fileExists:()=>false,readFile:()=>undefined};
const ls=ts.createLanguageService(host);
const qi=ls.getQuickInfoAtPosition('input.ts',t.indexOf('u =')); 
console.log(qi.kind, ts.displayPartsToString(qi.displayParts));
