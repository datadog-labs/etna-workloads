import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = "import Foo \n\nfunction fromBar() {}\n";
const host = {
  getScriptFileNames: () => ["/a.js"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "/a.js" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({ allowJs: true }),
  getDefaultLibFileName: () => "/lib.d.ts", fileExists: f => f === "/a.js", readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
const r = ls.getCompletionsAtPosition("/a.js", text.indexOf("\n"), { includeCompletionsForImportStatements: true, includeInsertTextCompletions: true });
console.log(JSON.stringify((r?.entries ?? []).map(e => e.name)));
