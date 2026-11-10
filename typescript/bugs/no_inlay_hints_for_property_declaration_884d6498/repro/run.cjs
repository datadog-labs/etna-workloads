const ts=require(process.env.TYPESCRIPT);
const t=require('fs').readFileSync('input.ts','utf8');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(t):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({strict:true}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?t:undefined};
const ls=ts.createLanguageService(host);
const h=ls.provideInlayHints('input.ts',{start:0,length:t.length},{includeInlayPropertyDeclarationTypeHints:true});
console.log(JSON.stringify(h.map(x=>[x.text,x.position])));
