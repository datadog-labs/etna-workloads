const ts=require(process.env.TYPESCRIPT);
const src="function f1<T >() {}\nfunction f2<T ext>() {}\n";
const host={getScriptFileNames:()=>["a.ts"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f==="a.ts"?ts.ScriptSnapshot.fromString(src):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:f=>f==="a.ts",readFile:f=>f==="a.ts"?src:undefined};
const ls=ts.createLanguageService(host);
for(const m of ["f1<T ","f2<T ext"]){const p=src.indexOf(m)+m.length;
const c=ls.getCompletionsAtPosition("a.ts",p,{});
console.log(m,!!c&&c.entries.some(e=>e.name==="extends"));}
