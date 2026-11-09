const ts=require(process.env.TYPESCRIPT);
const src=`import {
    b,
    a,
    c,
} from "foo";
console.log(a, b, c);
`;
const host={getScriptFileNames:()=>["a.ts"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f==="a.ts"?ts.ScriptSnapshot.fromString(src):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:f=>f==="a.ts",readFile:f=>f==="a.ts"?src:undefined};
const ls=ts.createLanguageService(host);
const ch=ls.organizeImports({type:"file",fileName:"a.ts"},{},{});
for(const c of ch)for(const t of c.textChanges)console.log(JSON.stringify(t.newText));
