import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
 "/common.ts": "export const x = 1;\n",
 "/a.ts": 'import { x } from "./common";\nexport const bar = x;\n',
 "/b.ts": 'import { x } from "./common";\nexport const foo = x;\n',
};
const host = {
 getScriptFileNames: () => Object.keys(files),
 getScriptVersion: () => "1",
 getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
 getCurrentDirectory: () => "/",
 getCompilationSettings: () => ({}),
 getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => f in files,
 readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const text = files["/a.ts"];
const start = text.indexOf("export const bar");
const range = { pos: start, end: text.length };
const edits = ls.getEditsForRefactor("/a.ts", {}, range, "Move to file", "Move to file", {}, { targetFile: "/b.ts" });
for (const fc of edits?.edits ?? []) { console.log("== " + fc.fileName); console.log(JSON.stringify(fc.textChanges)); }
