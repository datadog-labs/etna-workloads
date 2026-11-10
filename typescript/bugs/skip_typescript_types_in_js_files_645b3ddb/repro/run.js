const ts=require(process.env.TYPESCRIPT),fs=require('fs');
const text=fs.readFileSync('a.js','utf8');
const opts={allowJs:true,checkJs:true,noEmit:true};
const host={getScriptFileNames:()=>['a.js'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='a.js'?ts.ScriptSnapshot.fromString(text):ts.ScriptSnapshot.fromString(ts.sys.readFile(f)||''),getCurrentDirectory:()=>'.',getCompilationSettings:()=>opts,getDefaultLibFileName:o=>ts.getDefaultLibFilePath(o),fileExists:f=>f==='a.js'||ts.sys.fileExists(f),readFile:f=>f==='a.js'?text:ts.sys.readFile(f)};
const ls=ts.createLanguageService(host);
const i=text.indexOf('export const');
console.log(ls.getSemanticDiagnostics('a.js').map(d=>d.code));
const d=ls.getSemanticDiagnostics('a.js')[0];
const fixes=ls.getCodeFixesAtPosition('a.js',d.start,d.start+d.length,[d.code],{},{});
for(const f of fixes){console.log(f.description);for(const c of f.changes)for(const t of c.textChanges)console.log(t.newText);}
