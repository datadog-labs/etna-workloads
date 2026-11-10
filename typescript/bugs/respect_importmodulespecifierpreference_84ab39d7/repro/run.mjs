import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/project/tsconfig.json": JSON.stringify({ compilerOptions: { paths: { "~/noIndex/*": ["./src/noIndex/*"], "~/withIndex": ["./src/withIndex/index.ts"] } } }),
  "/project/package.json": "{}",
  "/project/src/noIndex/a.ts": "export const myFunctionA = () => {};",
  "/project/src/withIndex/b.ts": "export const myFunctionB = () => {};",
  "/project/src/withIndex/index.ts": "export * from './b';",
  "/project/src/reproduction/1.ts": "myFunctionA;\nmyFunctionB;\n",
};
const host = {
  getCompilationSettings: () => ({ paths: { "~/noIndex/*": ["./src/noIndex/*"], "~/withIndex": ["./src/withIndex/index.ts"] }, pathsBasePath: "/project" }),
  getScriptFileNames: () => Object.keys(files).filter(f => f.endsWith(".ts")),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/project",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
  useCaseSensitiveFileNames: () => true,
};
const ls = ts.createLanguageService(host);
const f = "/project/src/reproduction/1.ts";
for (const pref of ["non-relative", "relative", "project-relative"]) {
  console.log("== " + pref);
  for (const [name, code] of [["myFunctionA", 2304], ["myFunctionB", 2304]]) {
    const pos = files[f].indexOf(name);
    const fixes = ls.getCodeFixesAtPosition(f, pos, pos + name.length, [code], {}, { importModuleSpecifierPreference: pref });
    console.log(name, fixes.map(x => x.description));
  }
}
