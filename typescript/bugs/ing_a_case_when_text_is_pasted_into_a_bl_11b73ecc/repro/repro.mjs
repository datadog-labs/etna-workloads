import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/p/c.ts": "",
  "/p/a.ts": "export const abc = 10;",
  "/p/b.ts": 'import { abc } from "./a";\n\nconsole.log(abc);\n\nconsole.log("abc");',
};
const host = {
  getCompilationSettings: () => ({ lib: ["lib.es5.d.ts"] }),
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/p",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const b = files["/p/b.ts"];
const pos = b.indexOf("console.log(abc);");
const r = ls.getPasteEdits({
  targetFile: "/p/c.ts",
  pastedText: ["console.log(abc);"],
  pasteLocations: [{ pos: 0, end: 0 }],
  copiedFrom: { file: "/p/b.ts", range: [{ pos, end: pos + 17 }] },
  preferences: {},
}, { newLineCharacter: "\n", indentSize: 4, tabSize: 4 });
console.log(JSON.stringify(r, null, 1));
