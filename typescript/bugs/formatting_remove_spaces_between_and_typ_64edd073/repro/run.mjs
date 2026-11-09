import fs from 'fs';
import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync('input.ts','utf8');
const host = {
  getScriptFileNames:()=>['input.ts'], getScriptVersion:()=>'1',
  getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,
  getCurrentDirectory:()=>'.', getCompilationSettings:()=>({}),
  getDefaultLibFileName:()=>'lib.d.ts', fileExists:f=>f==='input.ts', readFile:f=>f==='input.ts'?text:undefined,
};
const ls = ts.createLanguageService(host);
const edits = ls.getFormattingEditsForDocument('input.ts', ts.getDefaultFormatCodeSettings());
let out = text;
for (const e of [...edits].reverse()) out = out.slice(0,e.span.start)+e.newText+out.slice(e.span.start+e.span.length);
console.log(out);
