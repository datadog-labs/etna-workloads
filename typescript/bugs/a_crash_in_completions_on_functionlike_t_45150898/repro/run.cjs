const ts=require(process.env.TYPESCRIPT);
const fs=require('fs');
const f="input.ts";const text=fs.readFileSync(f,'utf8');
const host={getCompilationSettings:()=>({lib:["lib.es5.d.ts"]}),getScriptFileNames:()=>[f],getScriptVersion:()=>"1",
getScriptSnapshot:n=>n===f?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>".",getDefaultLibFileName:o=>ts.getDefaultLibFilePath(o),
fileExists:n=>n===f,readFile:n=>n===f?text:undefined};
const ls=ts.createLanguageService(host);
{const pos=text.indexOf("function(")+8;
try{const c=ls.getCompletionsAtPosition(f,pos,{});console.log(pos,c?c.entries.length>0:c);}catch(e){console.log(pos,"crash");}}
