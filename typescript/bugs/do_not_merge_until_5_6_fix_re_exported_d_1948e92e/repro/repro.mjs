import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/node_modules/example/package.json": '{ "name": "example", "main": "dist/index.js" }',
  "/node_modules/example/dist/nested/module.d.ts": "declare const defaultExport: () => void;\ndeclare const namedExport: () => void;\nexport default defaultExport;\nexport { namedExport };\n",
  "/node_modules/example/dist/index.d.ts": 'export { default, namedExport } from "./nested/module";\n',
  "/index.mjs": 'import { namedExport } from "example";\ndefaultExp',
};
const opts = { lib: ["lib.es5.d.ts"], module: ts.ModuleKind.Preserve, checkJs: true, allowJs: true };
const host = {
  getCompilationSettings: () => opts,
  getScriptFileNames: () => ["/index.mjs", "/node_modules/example/dist/index.d.ts", "/node_modules/example/dist/nested/module.d.ts"],
  ["getScript"+"Ver"+"sion"]: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
  directoryExists: d => Object.keys(files).some(f => f.startsWith(d.replace(/\/$/, "") + "/")),
  useCaseSensitiveFileNames: () => true,
};
const ls = ts.createLanguageService(host);
const pos = files["/index.mjs"].length;
const r = ls.getCompletionsAtPosition("/index.mjs", pos, { includeCompletionsForModuleExports: true, allowIncompleteCompletions: true });
console.log((r?.entries ?? []).filter(e => e.source).map(e => `${e.name} from ${e.source}`).join("\n") || "no auto-import entries");
