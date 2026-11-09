import fs from 'fs';
import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync('input.ts','utf8');
const host = {
  getCompilationSettings: () => ({}),
  getScriptFileNames: () => ['input.ts'],
  getScriptVersion: () => '1',
  getScriptSnapshot: f => f==='input.ts' ? ts.ScriptSnapshot.fromString(text) : ts.ScriptSnapshot.fromString(ts.sys.readFile(f)??''),
  getCurrentDirectory: () => '.',
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f==='input.ts' || ts.sys.fileExists(f),
  readFile: f => f==='input.ts'? text : ts.sys.readFile(f),
};
const ls = ts.createLanguageService(host);
try {
  const c = ls.getCompletionsAtPosition('input.ts', text.indexOf("as ")+3, {});
  console.log(c ? c.entries.some(e=>e.name==='T') : 'none');
} catch (e) { console.log('threw', e instanceof TypeError); }
