const ts=require(process.env.TYPESCRIPT);
const src=require("fs").readFileSync("input.ts","utf8");
const f="input.ts";
const host={getScriptFileNames:()=>[f],getScriptVersion:()=>"1",getScriptSnapshot:n=>n===f?ts.ScriptSnapshot.fromString(src):undefined,getCurrentDirectory:()=>"",getCompilationSettings:()=>({noLib:true}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:n=>n===f,readFile:n=>n===f?src:undefined};
const ls=ts.createLanguageService(host);
const d=ls.getDefinitionAtPosition(f,src.lastIndexOf("id"))||[];
console.log(JSON.stringify(d.map(x=>({n:x.name,s:x.textSpan.start,k:x.kind}))));
