import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
 "/bar.ts": "//\n",
 "/a.ts": "import { b } from './other';\nconst p = 0;\nconst y: string = p + b;\n",
 "/other.ts": "export const b = 1;\n",
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
const start = files["/a.ts"].indexOf("const y"), end = files["/a.ts"].length - 1;
const edits = ls.getEditsForRefactor("/a.ts", {}, {pos:start,end}, "Move to file", "Move to file", {}, {targetFile:"/bar.ts"});
for (const e of edits.edits) { console.log("== " + e.fileName); for (const t of e.textChanges) console.log(JSON.stringify(t)); }
