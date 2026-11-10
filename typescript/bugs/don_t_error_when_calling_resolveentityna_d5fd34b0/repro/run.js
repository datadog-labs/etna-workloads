const ts=require(process.env.TYPESCRIPT),fs=require('fs');
const t=fs.readFileSync('input.ts','utf8');
const lib=ts.getDefaultLibFilePath({});
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(t):fs.existsSync(f)?ts.ScriptSnapshot.fromString(fs.readFileSync(f,'utf8')):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({}),getDefaultLibFileName:()=>lib,fileExists:f=>f==='input.ts'||fs.existsSync(f),readFile:f=>f==='input.ts'?t:fs.readFileSync(f,'utf8')};
const ls=ts.createLanguageService(host);
console.log(ls.getEncodedSemanticClassifications('input.ts',{start:0,length:t.length},'2020').spans.length);
const d=ls.getSemanticDiagnostics('input.ts');
console.log(d.length);
d.forEach(x=>console.log(ts.flattenDiagnosticMessageText(x.messageText,'\n')));
