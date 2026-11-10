import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
import fs from 'fs';
const text = fs.readFileSync('a.js','utf8');
const host = {
  getScriptFileNames:()=>['a.js'], getScriptVersion:()=>'1', getScriptSnapshot:f=>f==='a.js'?ts.ScriptSnapshot.fromString(text):undefined,
  getCurrentDirectory:()=>'/', getCompilationSettings:()=>({allowJs:true}), getDefaultLibFileName:()=>'lib.d.ts',
  fileExists:f=>f==='a.js', readFile:f=>f==='a.js'?text:undefined,
};
const ls = ts.createLanguageService(host);
const s = text.indexOf('Foo');
try {
  const r = ls.getEditsForRefactor('a.js',{},{pos:s,end:s+3},'Extract type','Extract to typedef',{});
  console.log(JSON.stringify(r&&r.edits));
} catch(e){ console.log('threw', String(e.message).split('\n')[0]); }
