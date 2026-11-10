const ts = require(process.env.TYPESCRIPT);
const files = { "/a.ts": "export const a = 1;" };
const host = ts.createCompilerHost({ noEmit: true });
const orig = host.getSourceFile;
host.getSourceFile = (f, ...r) => f === "/a.ts" ? ts.createSourceFile(f, files[f], r[0]) : orig(f, ...r);
host.fileExists = f => f === "/a.ts" || ts.sys.fileExists(f);
const opts = { noEmit: true, target: ts.ScriptTarget.ES2015 };
const p1 = ts.createProgram(["/a.ts"], opts, host);
files["/a.ts"] = "export const a = 2;";
const p2 = ts.createProgram(["/a.ts"], opts, host, p1);
for (const p of [p1, p2])
  console.log(p.getSourceFiles().filter(f => p.isSourceFileDefaultLibrary(f)).length > 0, p.structureIsReused);
