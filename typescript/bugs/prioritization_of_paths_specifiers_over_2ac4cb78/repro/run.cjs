const ts = require(process.env.TYPESCRIPT);
const files = {
 "/proj/tsconfig.json": "{}",
 "/proj/node_modules/@woltlab/wcf/ts/WoltLabSuite/Core/Component/Dialog.ts": "export class Dialog {}",
 "/proj/ts/main.ts": "Dialog",
};
const opts = { module: ts.ModuleKind.AMD, moduleResolution: ts.ModuleResolutionKind.Node10, rootDir: "/proj/ts", baseUrl: "/proj", paths: { "*": ["node_modules/@woltlab/wcf/ts/*"] }, configFilePath: "/proj/tsconfig.json" };
const host = {
 getCompilationSettings: () => opts,
 getScriptFileNames: () => Object.keys(files).filter(f => f.endsWith(".ts")),
 getScriptVersion: () => "1",
 getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
 getCurrentDirectory: () => "/proj",
 getDefaultLibFileName: () => "/lib.d.ts",
 fileExists: f => f in files,
 readFile: f => files[f],
 directoryExists: d => Object.keys(files).some(f => f.startsWith(d.replace(/\/$/, "") + "/")),
 getDirectories: () => [],
 useCaseSensitiveFileNames: () => true,
};
const ls = ts.createLanguageService(host);
const fixes = ls.getCodeFixesAtPosition("/proj/ts/main.ts", 0, 6, [2304], {}, { includeCompletionsForModuleExports: true });
for (const f of fixes) console.log(f.description);
