const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const text=fs.readFileSync('input.ts','utf8');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({strict:true}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?text:undefined};
const ls=ts.createLanguageService(host);
for(const m of ['const Unit','Unit\n','Fn()','const X']){
 let pos=text.indexOf(m);if(m==='const Unit'||m==='const X')pos+=6;
 const q=ls.getQuickInfoAtPosition('input.ts',pos);
 console.log(JSON.stringify(m),q&&ts.displayPartsToString(q.displayParts));
}
