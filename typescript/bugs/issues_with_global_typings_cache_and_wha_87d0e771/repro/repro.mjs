import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = { "/home/cache/typescript/node_modules/@types/node/index.d.ts": "import 'missing-mod';" };
const host = {
  getSourceFile: (f, l) => files[f] !== undefined ? ts.createSourceFile(f, files[f], l) : undefined,
  getDefaultLibFileName: () => "/lib.d.ts",
  writeFile() {}, getCurrentDirectory: () => "/home/cache/typescript",
  getCanonicalFileName: f => f, useCaseSensitiveFileNames: () => true, getNewLine: () => "\n",
  fileExists: f => files[f] !== undefined, readFile: f => files[f],
  directoryExists: d => d === "/home/cache/typescript/node_modules" || d === "/home/cache/typescript/node_modules/@types" || d === "/home/cache/typescript/node_modules/@types/node" || d === "/home/cache/typescript" || d === "/home/cache" || d === "/home" || d === "/",
  getGlobalTypingsCacheLocation: () => "/home/cache/typescript",
  trace: s => console.log(s),
};
ts.createProgram({ rootNames: ["/home/cache/typescript/node_modules/@types/node/index.d.ts"], options: { noLib: true, traceResolution: true, moduleResolution: ts.ModuleResolutionKind.Node10 }, host });
