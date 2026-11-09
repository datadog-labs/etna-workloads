const ts=require(process.env.TYPESCRIPT);const fs=require("fs");
const text=fs.readFileSync("input.ts","utf8");
const host={getScriptFileNames:()=>["input.ts"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f==="input.ts"?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:f=>f==="input.ts",readFile:f=>f==="input.ts"?text:undefined};
const ls=ts.createLanguageService(host);
const ch=ls.organizeImports({type:"file",fileName:"input.ts"},{},{});
let out=text;
for(const c of ch)for(const t of c.textChanges.slice().reverse())out=out.slice(0,t.span.start)+t.newText+out.slice(t.span.start+t.span.length);
console.log(out);
