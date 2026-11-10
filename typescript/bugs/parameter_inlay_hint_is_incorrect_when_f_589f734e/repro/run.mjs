import {createRequire} from 'module';
import fs from 'fs';
const ts=createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text=fs.readFileSync('input.ts','utf8');
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>({strict:true}),getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?text:undefined};
const ls=ts.createLanguageService(host);
const hints=ls.provideInlayHints('input.ts',{start:0,length:text.length},{includeInlayFunctionParameterTypeHints:true});
for(const h of hints){const l=text.slice(0,h.position).split('\n');console.log(l.length+':'+l[l.length-1].length,JSON.stringify(h.text))}
