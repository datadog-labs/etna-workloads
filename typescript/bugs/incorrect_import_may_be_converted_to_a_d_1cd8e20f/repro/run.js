const ts=require(process.env.TYPESCRIPT);
const opts={allowSyntheticDefaultImports:true,module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2020};
const files=["a.ts","b.ts"];
const host=ts.createCompilerHost(opts);
const p=ts.createProgram(files,opts,host);
const ls=ts.createLanguageService({getCompilationSettings:()=>opts,getScriptFileNames:()=>files,getScriptVersion:()=>"1",getScriptSnapshot:f=>require("fs").existsSync(f)?ts.ScriptSnapshot.fromString(require("fs").readFileSync(f,"utf8")):undefined,getCurrentDirectory:()=>process.cwd(),getDefaultLibFileName:o=>ts.getDefaultLibFilePath(o),fileExists:ts.sys.fileExists,readFile:ts.sys.readFile});
for(const d of ls.getSuggestionDiagnostics("b.ts"))console.log(d.code,d.messageText);
console.log("done");
