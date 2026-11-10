import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files = {
"/a.ts": "export const a = 1;\nexport const b = 1;\n",
"/b.ts": "export {\n    /** @deprecated a is deprecated */\n    a\n} from \"./a\";\n",
"/c.ts": "export {\n    a\n} from \"./b\";\n",
"/d.ts": "import * as _ from \"./c\";\n_.a;\n",
};
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ module: ts.ModuleKind.ESNext }),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const d = ls.getSuggestionDiagnostics("/d.ts");
console.log(JSON.stringify(d.map(x => [x.code, x.start, x.length, !!x.reportsDeprecated, ts.flattenDiagnosticMessageText(x.messageText, "\n")])));
