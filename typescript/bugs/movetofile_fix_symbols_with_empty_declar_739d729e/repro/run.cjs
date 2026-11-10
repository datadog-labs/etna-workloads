const ts=require(process.env.TYPESCRIPT);
const files={"/orig.ts":"export const variable = undefined;\n"};
const host={getScriptFileNames:()=>Object.keys(files),getScriptVersion:()=>"1",
getScriptSnapshot:f=>files[f]!==undefined?ts.ScriptSnapshot.fromString(files[f]):undefined,
getCurrentDirectory:()=>"/",getCompilationSettings:()=>({module:ts.ModuleKind.ESNext,moduleResolution:ts.ModuleResolutionKind.Bundler}),
getDefaultLibFileName:()=>"/lib.d.ts",fileExists:f=>f in files,readFile:f=>files[f],useCaseSensitiveFileNames:()=>true};
const ls=ts.createLanguageService(host);
const e=ls.getEditsForRefactor("/orig.ts",{},{pos:0,end:files["/orig.ts"].length-1},"Move to file","Move to file",{},{targetFile:"/new.ts"});
console.log(JSON.stringify(e&&e.edits,null,1));
