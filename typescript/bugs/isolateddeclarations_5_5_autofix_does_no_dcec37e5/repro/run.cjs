const ts = require(process.env.TYPESCRIPT);
const files = {
 "/a.tsx": 'export const x = <div aria-label="label text" />;',
 "/node_modules/react/package.json": '{"name":"react","types":"index.d.ts"}',
 "/node_modules/react/index.d.ts": 'export = React;\ndeclare namespace JSX { interface Element extends GlobalJSXElement { } interface IntrinsicElements extends GlobalJSXIntrinsicElements { } }\ndeclare namespace React { }\ndeclare global { namespace JSX { interface Element { } interface IntrinsicElements { [x: string]: any; } } }\ninterface GlobalJSXElement extends JSX.Element {}\ninterface GlobalJSXIntrinsicElements extends JSX.IntrinsicElements {}',
 "/node_modules/react/jsx-runtime.d.ts": "import './';",
 "/node_modules/react/jsx-dev-runtime.d.ts": "import './';",
};
const opts = { isolatedDeclarations: true, declaration: true, jsx: ts.JsxEmit.ReactJSX, target: ts.ScriptTarget.ES2018, moduleResolution: ts.ModuleResolutionKind.Bundler, module: ts.ModuleKind.ESNext };
const host = {
 getScriptFileNames: () => Object.keys(files), getScriptVersion: () => "1",
 getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
 getCurrentDirectory: () => "/", getCompilationSettings: () => opts,
 getDefaultLibFileName: () => "/lib.d.ts", directoryExists: d => Object.keys(files).some(f => f.startsWith(d.replace(/\/?$/,"/"))), fileExists: f => f in files, readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const diags = ls.getSemanticDiagnostics("/a.tsx");
const code = diags.map(d => d.code);
console.log("codes", code.join());
const fixes = ls.getCodeFixesAtPosition("/a.tsx", diags[0].start, diags[0].start + diags[0].length, [...new Set(code)], {}, {});
for (const f of fixes) { console.log(f.description); for (const c of f.changes) for (const t of c.textChanges) console.log(JSON.stringify(t)); }
