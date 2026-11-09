const ts=require(process.env.TYPESCRIPT),fs=require('fs');
const text=fs.readFileSync('a.tsx','utf8');
const o={jsx:ts.JsxEmit.React};
const host={getScriptFileNames:()=>['a.tsx'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f=='a.tsx'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>o,getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f=='a.tsx',readFile:f=>f=='a.tsx'?text:undefined};
const ls=ts.createLanguageService(host);
const qi=ls.getQuickInfoAtPosition('a.tsx',text.indexOf('prop:foo="')+1);
console.log(qi?ts.displayPartsToString(qi.displayParts)+' | '+ts.displayPartsToString(qi.documentation):'none');
