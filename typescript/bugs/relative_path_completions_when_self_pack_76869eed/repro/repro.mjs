import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files = {
 "/package.json": '{"typesVersions":{"*":{"*":["./src/*"]}}}',
 "/src/add.ts": "export function add(a: number, b: number) { return a + b; }",
 "/src/index.ts": 'import { add } from "./";',
};
const opts = { module: ts.ModuleKind.CommonJS, moduleResolution: ts.ModuleResolutionKind.Node10 };
const host = {
 getCompilationSettings: () => opts,
 getScriptFileNames: () => ["/src/add.ts", "/src/index.ts"],
 getScriptVersion: () => "1",
 getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
 getCurrentDirectory: () => "/",
 getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => files[f] !== undefined,
 readFile: f => files[f],
 readDirectory: (p) => Object.keys(files).filter(f => f.startsWith(p === "/" ? "/" : p)),
 directoryExists: d => Object.keys(files).some(f => f.startsWith(d.endsWith("/") ? d : d + "/")) || d === "/",
 getDirectories: d => d === "/" ? ["src"] : [],
};
const ls = ts.createLanguageService(host);
const pos = files["/src/index.ts"].indexOf('"./"') + 3;
const r = ls.getCompletionsAtPosition("/src/index.ts", pos, {});
console.log(JSON.stringify(r && r.entries.map(e => e.name)));
