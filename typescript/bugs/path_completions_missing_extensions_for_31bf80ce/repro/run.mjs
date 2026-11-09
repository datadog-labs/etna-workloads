import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
 "/node_modules/repo/package.json": '{"name":"repo","exports":{"./*":"./src/*"}}',
 "/node_modules/repo/src/card.tsx": "export {};",
 "/main.ts": 'import { } from "repo/";',
};
const opts = { module: ts.ModuleKind.Preserve, moduleResolution: ts.ModuleResolutionKind.Bundler, allowImportingTsExtensions: true, jsx: ts.JsxEmit.React };
const host = {
 getScriptFileNames: () => ["/main.ts","/node_modules/repo/src/card.tsx"],
 getScriptVersion: () => "1",
 getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
 getCurrentDirectory: () => "/",
 getCompilationSettings: () => opts,
 getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => files[f] !== undefined,
 readFile: f => files[f],
 readDirectory: (d,exts) => Object.keys(files).filter(f => f.startsWith(d.endsWith("/")?d:d+"/") && (!exts || exts.some(e => f.endsWith(e)))),
 directoryExists: d => Object.keys(files).some(f => f.startsWith(d.endsWith("/")?d:d+"/")),
 getDirectories: d => { const p = d.endsWith("/")?d:d+"/"; return [...new Set(Object.keys(files).filter(f=>f.startsWith(p)&&f.slice(p.length).includes("/")).map(f=>f.slice(p.length).split("/")[0]))]; },
 realpath: f => f,
};
const ls = ts.createLanguageService(host);
const c = ls.getCompletionsAtPosition("/main.ts", files["/main.ts"].indexOf('/"')+1, {});
console.log(JSON.stringify(c && c.entries.map(e => [e.name, e.kindModifiers])));
