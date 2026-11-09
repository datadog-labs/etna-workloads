import fs from 'fs';
import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync('index.js','utf8');
const host = {
  getScriptFileNames:()=>['index.js'], getScriptVersion:()=>'1',
  getScriptSnapshot:f=>f==='index.js'?ts.ScriptSnapshot.fromString(text):undefined,
  getCurrentDirectory:()=>'/', getCompilationSettings:()=>({allowJs:true,checkJs:true,strict:true}),
  getDefaultLibFileName:()=>'lib.d.ts', fileExists:f=>f==='index.js', readFile:f=>f==='index.js'?text:undefined,
};
const ls = ts.createLanguageService(host);
try {
  const r = ls.getDefinitionAtPosition('index.js', text.lastIndexOf('Test'));
  console.log(JSON.stringify((r||[]).map(d=>[d.name,d.kind,d.textSpan])));
} catch(e){ console.log('threw:', e.message); }
