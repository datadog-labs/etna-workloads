const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const files=['types.d.ts','index.ts'];
const opts={module:ts.ModuleKind.Preserve,lib:['lib.es5.d.ts'],noEmit:true};
const host={getScriptFileNames:()=>files,getScriptVersion:()=>'1',getScriptSnapshot:f=>fs.existsSync(f)?ts.ScriptSnapshot.fromString(fs.readFileSync(f,'utf8')):undefined,getCurrentDirectory:()=>process.cwd(),getCompilationSettings:()=>opts,getDefaultLibFileName:o=>ts.getDefaultLibFilePath(o),fileExists:f=>fs.existsSync(f),readFile:f=>fs.readFileSync(f,'utf8')};
const ls=ts.createLanguageService(host);
for(const t of ['comp','fix']){
try{
if(t=='comp'){const r=ls.getCompletionsAtPosition('index.ts',2,{includeCompletionsForModuleExports:true});
console.log('completions', r?r.entries.length:'none');}
else{const r=ls.getCodeFixesAtPosition('index.ts',0,2,[2304],{},{});
console.log('fixes', r.map(f=>f.description));}
}catch(e){console.log(t,'crash',e instanceof RangeError?'RangeError':e.message)}}
