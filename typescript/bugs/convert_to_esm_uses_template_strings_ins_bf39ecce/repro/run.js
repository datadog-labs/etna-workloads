const ts=require(process.env.TYPESCRIPT);
const text="const foo = require(`foo`);\n";
const opts={module:ts.ModuleKind.CommonJS,esModuleInterop:false,allowSyntheticDefaultImports:false};
const host={getScriptFileNames:()=>["/a.ts"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f==="/a.ts"?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>opts,getDefaultLibFileName:()=>"/lib.d.ts",fileExists:f=>f==="/a.ts",readFile:f=>f==="/a.ts"?text:undefined};
const ls=ts.createLanguageService(host);
const fixes=ls.getCodeFixesAtPosition("/a.ts",text.indexOf("require"),text.indexOf("require")+1,[80005],ts.getDefaultFormatCodeSettings(),{});
for(const f of fixes)for(const c of f.changes)for(const t of c.textChanges)console.log(f.description,"=>",t.newText);
