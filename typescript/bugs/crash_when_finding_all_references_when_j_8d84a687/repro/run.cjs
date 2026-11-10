const ts=require(process.env.TYPESCRIPT),fs=require('fs');
const files={'/a.js':fs.readFileSync('a.js','utf8'),'/b.js':fs.readFileSync('b.js','utf8')};
const host={getScriptFileNames:()=>Object.keys(files),getScriptVersion:()=>'1',getScriptSnapshot:f=>files[f]!==undefined?ts.ScriptSnapshot.fromString(files[f]):undefined,getCurrentDirectory:()=>'/',getCompilationSettings:()=>({allowJs:true,checkJs:true}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f in files,readFile:f=>files[f],};
const ls=ts.createLanguageService(host);
for (const [f,pos] of [['/a.js',files['/a.js'].indexOf('a()')],['/b.js',files['/b.js'].indexOf('a,')]]){
try{const r=ls.findReferences(f,pos);console.log(f,JSON.stringify((r||[]).map(x=>x.references.map(y=>y.fileName+':'+y.textSpan.start))));}catch(e){console.log(f,'ERR',e.message.split('\n')[0]);}}
