import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
 "/tsconfig.json": "{}",
 "/src/a.ts": "export function a() {\n    b();\n}\nexport function b() {\n}\n",
};
const opts = { moduleResolution: ts.ModuleResolutionKind.Bundler, module: ts.ModuleKind.ESNext, baseUrl: "/", paths: { "@foo/*": ["src/*"] } };
const host = {
 getCompilationSettings: () => opts,
 getScriptFileNames: () => ["/src/a.ts"],
 getScriptVersion: () => "1",
 getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
 getCurrentDirectory: () => "/",
 getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => f in files, readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const text = files["/src/a.ts"];
const start = text.indexOf("export function b");
const prefs = { importModuleSpecifierPreference: "non-relative" };
const edits = ls.getEditsForRefactor("/src/a.ts", {}, { pos: start, end: text.length }, "Move to a new file", "Move to a new file", prefs);
for (const e of edits.edits) { console.log("== " + e.fileName); for (const t of e.textChanges) console.log(JSON.stringify(t.newText)); }
