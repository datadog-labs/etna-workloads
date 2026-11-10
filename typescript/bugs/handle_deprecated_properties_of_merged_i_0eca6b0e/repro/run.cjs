const ts=require(process.env.TYPESCRIPT);
const src=require("fs").readFileSync("input.ts","utf8");
const h=ts.createCompilerHost({});
const f=ts.createSourceFile("input.ts",src,99,true);
const o={noEmit:true};
const orig=h.getSourceFile;
h.getSourceFile=(n,...a)=>n==="input.ts"?f:orig(n,...a);
const p=ts.createProgram(["input.ts"],o,h);
for(const d of p.getSuggestionDiagnostics?[]:[]);
const ls=p.getTypeChecker();
const ds=[];
// use language service
const host={getScriptFileNames:()=>["input.ts"],getScriptVersion:()=>"1",getScriptSnapshot:n=>n==="input.ts"?ts.ScriptSnapshot.fromString(src):ts.ScriptSnapshot.fromString(ts.sys.readFile(n)||""),getCurrentDirectory:()=>".",getCompilationSettings:()=>o,getDefaultLibFileName:ts.getDefaultLibFilePath,fileExists:n=>n==="input.ts"||ts.sys.fileExists(n),readFile:n=>n==="input.ts"?src:ts.sys.readFile(n)};
const l=ts.createLanguageService(host);
for(const d of l.getSuggestionDiagnostics("input.ts"))console.log(d.code,d.start,ts.flattenDiagnosticMessageText(d.messageText,"\n"));
