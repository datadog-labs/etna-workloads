const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const t=fs.readFileSync('input.ts','utf8');
const h={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(t):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?t:undefined};
const ls=ts.createLanguageService(h);
const pos=t.lastIndexOf('b;');
const q=ls.getQuickInfoAtPosition('input.ts',pos);
console.log(ts.displayPartsToString(q.displayParts));console.log('doc:',ts.displayPartsToString(q.documentation));
