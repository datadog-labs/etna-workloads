const ts=require(process.env.TYPESCRIPT);
const f="input.ts",src=ts.sys.readFile(f);
const host={getScriptFileNames:()=>[f],getScriptVersion:()=>"1",getScriptSnapshot:n=>n===f?ts.ScriptSnapshot.fromString(src):undefined,getCurrentDirectory:()=>"",getCompilationSettings:()=>({strict:true}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:n=>n===f,readFile:n=>n===f?src:undefined};
const ls=ts.createLanguageService(host);
const pos=[src.indexOf("m({"),src.indexOf("$(")  ,src.lastIndexOf("$(")];
for(const p of pos){const q=ls.getQuickInfoAtPosition(f,p);console.log(ts.displayPartsToString(q&&q.displayParts));}
