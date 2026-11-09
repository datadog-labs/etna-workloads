import fs from 'fs';
import {createRequire} from 'module';
const ts=createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text=fs.readFileSync('input.ts','utf8');
const opts={};
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'/',getCompilationSettings:()=>opts,getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?text:undefined};
const ls=ts.createLanguageService(host);
const fixes=ls.getCodeFixesAtPosition('input.ts',0,3,[2304],{},{});
for(const f of fixes){console.log(f.description);for(const c of f.changes)for(const t of c.textChanges)console.log(t.newText);}
