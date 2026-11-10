const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const txt=fs.readFileSync('a.js','utf8');
const host={getScriptFileNames:()=>['a.js'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='a.js'?ts.ScriptSnapshot.fromString(txt):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({allowJs:true}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='a.js',readFile:f=>f==='a.js'?txt:undefined};
const ls=ts.createLanguageService(host);
for(const m of ['foo.x','foo = this']){
const pos=txt.indexOf(m);
const r=ls.findRenameLocations('a.js',pos,false,false,{});
console.log(m,JSON.stringify((r||[]).map(x=>[x.textSpan.start,x.textSpan.length])));}
