const ts=require(process.env.TYPESCRIPT);
const text="class C1 {\n    async #fo\n}\n";
const host={getScriptFileNames:()=>["/a.js"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f=="/a.js"?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({allowJs:true}),getDefaultLibFileName:()=>"/lib.d.ts",fileExists:f=>f=="/a.js",readFile:f=>f=="/a.js"?text:undefined};
const ls=ts.createLanguageService(host);
const r=ls.getCompletionsAtPosition("/a.js",text.indexOf("#fo")+3,{includeInsertTextCompletions:true});
console.log(r?r.entries.map(e=>e.name).join(","):"none");
