import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = `interface Foo {
    a?: boolean;
    b: boolean;
}
type A = { [K in keyof Foo]-?: { name: K, value: \`Foo \${Uppercase<K>}\` }}
const a: A = {};
`;
const lib = "interface Array<T>{} interface Boolean{} interface Function{} interface CallableFunction{} interface NewableFunction{} interface IArguments{} interface Number{} interface Object{} interface RegExp{} interface String{} type Uppercase<S extends string> = intrinsic;";
const opts = { strict: true, target: 99 };
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : ts.sys.fileExists(f) ? ts.ScriptSnapshot.fromString(ts.sys.readFile(f)) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => opts,
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o), fileExists: f => f === "a.ts" || ts.sys.fileExists(f), readFile: f => f === "a.ts" ? text : ts.sys.readFile(f),
};
const ls = ts.createLanguageService(host);
const start = text.indexOf("const a: A");
const diags = ls.getSemanticDiagnostics("a.ts");
const d = diags[0]; console.log(diags.map(x=>ts.flattenDiagnosticMessageText(x.messageText,"\n")));
const fixes = ls.getCodeFixesAtPosition("a.ts", start + 6, start + 7, [d.code], {}, {});
for (const f of fixes) if (f.fixName === "addMissingProperties" || /missing prop/i.test(f.description)) {
  console.log(f.description);
  for (const c of f.changes) for (const t of c.textChanges) console.log(t.newText);
}
