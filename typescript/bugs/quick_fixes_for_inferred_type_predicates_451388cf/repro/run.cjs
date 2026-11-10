const ts=require(process.env.TYPESCRIPT);
const src="function f(x: unknown) {\n  return typeof x === \"string\";\n}\n";
const host={getScriptFileNames:()=>["a.ts"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f=="a.ts"?ts.ScriptSnapshot.fromString(src):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({strict:true}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:f=>f=="a.ts",readFile:f=>f=="a.ts"?src:undefined};
const ls=ts.createLanguageService(host);
const pos=src.indexOf("f(");
const r=ls.getEditsForRefactor("a.ts",{},{pos,end:pos+1},"Infer function return type","Infer return type",{});
console.log(JSON.stringify(r&&r.edits.map(e=>e.textChanges)));
