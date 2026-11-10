import {createRequire} from 'module';
const require=createRequire(import.meta.url);
const ts=require(process.env.TYPESCRIPT);
const text=`enum E {
    A = 0,
    B = "B",
}
declare const u: E;
switch (u) {
    case E.
}
`;
const pos=text.indexOf("E.\n")+2;
const host={getScriptFileNames:()=>["/main.ts"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f==="/main.ts"?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({lib:["lib.es5.d.ts"]}),getDefaultLibFileName:o=>ts.getDefaultLibFilePath(o),fileExists:f=>f==="/main.ts",readFile:f=>f==="/main.ts"?text:undefined};
const ls=ts.createLanguageService(host);
const r=ls.getCompletionsAtPosition("/main.ts",pos,{includeCompletionsWithInsertText:true,includeCompletionsWithSnippetText:true});
console.log((r?.entries??[]).map(e=>e.name).filter(n=>!/^[A-Z]$/.test(n)||true).join("\n"));
