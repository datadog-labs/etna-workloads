import fs from 'fs';
import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync('a.js','utf8');
const opts = { allowJs: true, checkJs: true };
const host = {
  getScriptFileNames: () => ['a.js'], getScriptVersion: () => '1',
  getScriptSnapshot: f => f === 'a.js' ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => '.', getCompilationSettings: () => opts,
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f === 'a.js', readFile: f => f === 'a.js' ? text : undefined,
};
const ls = ts.createLanguageService(host);
const h = ls.getSignatureHelpItems('a.js', text.lastIndexOf('1'), {});
for (const i of h.items) console.log(ts.displayPartsToString(i.prefixDisplayParts), '|', ts.displayPartsToString(i.documentation));
