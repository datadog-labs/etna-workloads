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
const pos = text.indexOf('"foo"')+2;
const r = ls.findRenameLocations('input.ts', pos, false, false, {providePrefixAndSuffixTextForRename:true});
for (const l of r) console.log(l.textSpan.start, l.textSpan.length, JSON.stringify(l.prefixText), JSON.stringify(l.suffixText));
