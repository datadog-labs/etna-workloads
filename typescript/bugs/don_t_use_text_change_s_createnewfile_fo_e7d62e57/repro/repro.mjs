import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  '/bar.ts': '//\n',
  '/a.ts': "import { b } from './other';\nconst p = 0;\nconst y = p + b;\n",
  '/other.ts': 'export const b = 1;\n',
};
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => '1',
  getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => '/',
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => '/lib.d.ts',
  fileExists: f => f in files,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const text = files['/a.ts'];
const start = text.indexOf('const y');
const span = { pos: start, end: text.length - 1 };
const edits = ls.getEditsForRefactor('/a.ts', {}, span, 'Move to file', 'Move to file', undefined, { targetFile: '/bar.ts' });
for (const e of edits.edits) { console.log('== ' + e.fileName); for (const t of e.textChanges) console.log(JSON.stringify(t)); }
