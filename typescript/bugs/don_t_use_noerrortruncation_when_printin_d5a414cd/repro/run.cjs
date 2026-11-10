const ts=require(process.env.TYPESCRIPT),fs=require("fs");
const text=fs.readFileSync("input.ts","utf8");
const opts={noErrorTruncation:true};
const host={getScriptFileNames:()=>["input.ts"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f==="input.ts"?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>".",getCompilationSettings:()=>opts,getDefaultLibFileName:()=>"lib.d.ts",fileExists:f=>f==="input.ts",readFile:f=>f==="input.ts"?text:undefined};
const ls=ts.createLanguageService(host);
const qi=ls.getQuickInfoAtPosition("input.ts",text.indexOf("T"),undefined,1);
console.log(ts.displayPartsToString(qi.displayParts));
