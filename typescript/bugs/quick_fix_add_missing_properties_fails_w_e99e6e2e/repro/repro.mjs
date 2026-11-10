import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
 "/E.ts": "export enum E {\n  A,\n  B,\n}\n",
 "/foo.ts": 'import { E } from "./E";\ntype T = {\n  e: E,\n};\nconst t: T = { };\n',
};
const host = {
 getScriptFileNames: () => Object.keys(files),
 getScriptVersion: () => "1",
 getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
 getCurrentDirectory: () => "/",
 getCompilationSettings: () => ({ module: ts.ModuleKind.CommonJS, strict: true }),
 getDefaultLibFileName: () => "lib.d.ts",
 fileExists: f => f in files, readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const pos = files["/foo.ts"].indexOf("const t");
const diags = ls.getSemanticDiagnostics("/foo.ts");
const fixes = ls.getCodeFixesAtPosition("/foo.ts", pos+6, pos+7, [diags[0].code], {}, {});
for (const f of fixes) for (const c of f.changes) for (const t of c.textChanges) console.log(f.description, JSON.stringify(t.newText));
