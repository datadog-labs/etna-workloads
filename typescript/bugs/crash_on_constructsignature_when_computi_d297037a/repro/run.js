const ts=require(process.env.TYPESCRIPT),fs=require('fs');
const f="input.ts",text=fs.readFileSync(f,"utf8");
const host={getScriptFileNames:()=>[f],getScriptVersion:()=>"1",getScriptSnapshot:n=>n===f?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({strict:true,target:ts.ScriptTarget.ESNext}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:n=>n===f,readFile:n=>n===f?text:undefined};
const ls=ts.createLanguageService(host);
try{const h=ls.provideInlayHints(f,{start:0,length:text.length},{includeInlayVariableTypeHints:true,interactiveInlayHints:true});
console.log(JSON.stringify(h.map(x=>x.displayParts?x.displayParts.map(p=>p.text).join(""):x.text)));}catch(e){console.log("crash:",e.message.split("\n")[0]);}
