const ts = require(process.env.TYPESCRIPT);
const files = {
 "/p/tsconfig.json": "{}",
 "/p/node_modules/@types/node/index.d.ts": 'declare module "fs" {\n export function accessSync(path: string): void;\n}\n',
 "/p/node_modules/@types/fs-extra/index.d.ts": 'export * from "fs";\n',
 "/p/index.ts": "access",
};
const opts = { module: ts.ModuleKind.CommonJS, types: ["*"], lib: ["lib.d.ts"], noEmit: true };
const host = {
 getCompilationSettings: () => opts,
 getScriptFileNames: () => ["/p/index.ts", "/p/node_modules/@types/node/index.d.ts", "/p/node_modules/@types/fs-extra/index.d.ts"],
 getScriptVersion: () => "1",
 getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
 getCurrentDirectory: () => "/p",
 getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => files[f] !== undefined,
 readFile: f => files[f],
 directoryExists: d => Object.keys(files).some(f => f.startsWith(d.replace(/\/$/, "") + "/")),
 getDirectories: () => [],
};
files["/lib.d.ts"] = "";
const ls = ts.createLanguageService(host);
const prefs = { includeCompletionsForModuleExports: true, allowIncompleteCompletions: true };
const c = ls.getCompletionsAtPosition("/p/index.ts", 6, prefs);
for (const e of c.entries.filter(e => e.name === "accessSync")) {
  try {
    const d = ls.getCompletionEntryDetails("/p/index.ts", 6, e.name, {}, e.source, prefs, e.data);
    console.log(e.source, d && d.source.map(s=>s.text).join(""), d && JSON.stringify(d.codeActions && d.codeActions.map(a => a.description + JSON.stringify(a.changes.map(c=>c.textChanges)))));
  } catch (err) { console.log(e.source, "ERROR", err.message.split("\n")[0]); }
}
