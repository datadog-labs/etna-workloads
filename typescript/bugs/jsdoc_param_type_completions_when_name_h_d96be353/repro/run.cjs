const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const text=fs.readFileSync('input.js','utf8');
const pos=text.indexOf('{')+4;
const host={getScriptFileNames:()=>['input.js'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f=='input.js'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({allowJs:true,lib:['lib.es5.d.ts']}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f=='input.js',readFile:f=>f=='input.js'?text:undefined};
const ls=ts.createLanguageService(host);
const c=ls.getCompletionsAtPosition('input.js',pos,{});
const n=c?c.entries.map(e=>e.name):[];
console.log(n.length>1?'type completions':'param name only: '+n.join());
