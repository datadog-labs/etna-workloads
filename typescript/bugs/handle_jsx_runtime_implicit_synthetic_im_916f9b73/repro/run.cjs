const ts = require(process.env.TYPESCRIPT);
const files = {
 "/p/src/foo.ts": 'import * as x from "@foo/dir/jsx-runtime";\n',
 "/p/src/bar.tsx": "export default <div></div>;\n",
 "/p/src/dir/jsx-runtime.ts": "export {}\n",
};
const opts = {moduleResolution: ts.ModuleResolutionKind.Node10 ?? 2, module: ts.ModuleKind.ES2020, jsx: ts.JsxEmit.ReactJSX, jsxImportSource: "@foo/dir", moduleDetection: ts.ModuleDetectionKind.Force, ignoreDeprecations:"6.0", baseUrl:"/p", paths: {"@foo/dir/jsx-runtime": ["./src/dir/jsx-runtime"]}};
const host = {
 getCompilationSettings: () => opts,
 getScriptFileNames: () => Object.keys(files),
 getScriptVersion: () => "1",
 getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
 getCurrentDirectory: () => "/p",
 getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => f in files,
 readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const pos = files["/p/src/foo.ts"].indexOf('"@foo');
const r = ls.findReferences("/p/src/foo.ts", pos + 1) || [];
for (const g of r) for (const e of g.references) console.log(e.fileName, e.textSpan.start, e.textSpan.length);
console.log("groups", r.length);
