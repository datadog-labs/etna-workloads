const ts = require(process.env.TYPESCRIPT);
const files = {
 "/node_modules/foo/package.json": '{"name":"foo","exports":{"./*":"./dist/*.js"}}',
 "/node_modules/foo/dist/blah.d.ts": "export const blah = 0;",
 "/index.mts": 'import { } from "foo/";',
};
const host = {
 getScriptFileNames: () => ["/index.mts"],
 getScriptVersion: () => "1",
 getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
 getCurrentDirectory: () => "/",
 getCompilationSettings: () => ({ module: ts.ModuleKind.Node18 }),
 getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => files[f] !== undefined,
 readFile: f => files[f],
 directoryExists: d => Object.keys(files).some(f => f.startsWith(d.replace(/\/$/, "") + "/")),
 getDirectories: () => [],
 readDirectory: (d) => Object.keys(files).filter(f => f.startsWith(d.replace(/\/$/, "") + "/")),
 realpath: p => p,
 useCaseSensitiveFileNames: () => true,
};
const ls = ts.createLanguageService(host);
const pos = files["/index.mts"].indexOf('/";') + 1;
const r = ls.getCompletionsAtPosition("/index.mts", pos, {});
console.log(JSON.stringify(r && r.entries.map(e => e.name)));
