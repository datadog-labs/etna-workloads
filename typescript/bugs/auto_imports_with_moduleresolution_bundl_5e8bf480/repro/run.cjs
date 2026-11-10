const ts = require(process.env.TYPESCRIPT);
const files = {
 "/node_modules/dep/package.json": JSON.stringify({name:"dep",exports:{".":{custom:"./dist/index.js"}}}),
 "/node_modules/dep/dist/index.d.ts": "export const dep: number;",
 "/index.ts": "dep",
 "/package.json": JSON.stringify({dependencies:{dep:"*"}}),
};
const options = {module: ts.ModuleKind.ESNext, moduleResolution: ts.ModuleResolutionKind.Bundler, customConditions:["custom"], noEmit:true};
const host = {
 getCompilationSettings:()=>options, getScriptFileNames:()=>["/index.ts","/node_modules/dep/dist/index.d.ts"],
 getScriptVersion:()=>"1", getScriptSnapshot:f=>f in files?ts.ScriptSnapshot.fromString(files[f]):undefined,
 getCurrentDirectory:()=>"/", getDefaultLibFileName:()=>"/lib.d.ts",
 fileExists:f=>f in files, directoryExists:d=>Object.keys(files).some(k=>k.startsWith(d.replace(/\/?$/,"/"))), getDirectories:()=>[], readFile:f=>files[f],
};
const ls = ts.createLanguageService(host);
const fixes = ls.getCodeFixesAtPosition("/index.ts",0,3,[2304],{},{includeCompletionsForModuleExports:true});
for (const f of fixes) console.log(f.description);
