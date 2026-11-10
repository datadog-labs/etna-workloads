const ts=require(process.env.TYPESCRIPT);
const text="type Test = `T`;\n";
const host={getScriptFileNames:()=>["a.ts"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f==="a.ts"?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:f=>f==="a.ts",readFile:f=>f==="a.ts"?text:undefined};
const ls=ts.createLanguageService(host);
try{console.log(JSON.stringify(ls.findReferences("a.ts",text.indexOf("`")+2)));}catch(e){console.log("crash");}
