import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
 "/a.ts": "export type ExecutionPoint = string;\n",
 "/b.ts": 'import * as A from "./a";\n\nasync function fn1(point: A.ExecutionPoint) {}\n\nasync function fn2(point: A.ExecutionPoint) {}\n',
};
const host = {
 getScriptFileNames: () => Object.keys(files),
 getScriptVersion: () => "1",
 getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
 getCurrentDirectory: () => "/",
 getCompilationSettings: () => ({}),
 getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => files[f] !== undefined,
 readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const start = files["/b.ts"].indexOf("async function fn1");
const end = start + "async function fn1(point: A.ExecutionPoint) {}".length;
try {
const r = ls.getEditsForRefactor("/b.ts", { newLineCharacter: "\n", indentSize: 4 }, { pos: start, end }, "Move to a new file", "Move to a new file", {});
for (const e of r.edits) { console.log("== " + e.fileName); for (const t of e.textChanges) console.log(JSON.stringify(t)); }
} catch (e) { console.log("ERROR", e.message.split("\n")[0]); }
