import fs from 'fs';
import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync('input.ts','utf8');
const host = {
  getScriptFileNames: () => ['input.ts'],
  getScriptVersion: () => '1',
  getScriptSnapshot: f => f === 'input.ts' ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => '.',
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => 'lib.d.ts',
  fileExists: f => f === 'input.ts', readFile: f => f === 'input.ts' ? text : undefined,
};
const ls = ts.createLanguageService(host);
const r = ls.getCompletionsAtPosition('input.ts', text.length, { includeCompletionsWithInsertText: true });
for (const e of r.entries) console.log(e.name, e.insertText ?? '', e.sortText);
