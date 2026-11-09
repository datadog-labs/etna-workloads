const ts=require(process.env.TYPESCRIPT);
const src="class A<T> {}\nclass B implements A<string>{\n}\ninterface I extends A<number>{\n}\n";
const host={getScriptFileNames:()=>["a.ts"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f=="a.ts"?ts.ScriptSnapshot.fromString(src):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:f=>f=="a.ts",readFile:f=>f=="a.ts"?src:undefined};
const ls=ts.createLanguageService(host);
const edits=ls.getFormattingEditsForDocument("a.ts",ts.getDefaultFormatCodeSettings());
let out=src;for(const e of edits.sort((a,b)=>b.span.start-a.span.start))out=out.slice(0,e.span.start)+e.newText+out.slice(e.span.start+e.span.length);
console.log(out);
