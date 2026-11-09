import { createRequire } from "module";
import path from "path";
import fs from "fs";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const root = path.resolve("proj");
const active = new Map(); let n = 0;
const sys = {...ts.sys,
  watchFile(f, cb){ const id=n++; active.set(id,[f,cb]); return {close(){active.delete(id);}}; },
  watchDirectory(){ return {close(){}}; },
  setTimeout(cb){ cb(); return 0; }, clearTimeout(){},
  writeFile(){}, getCurrentDirectory:()=>root };
const host = ts.createWatchCompilerHost(path.join(root,"tsconfig.c.json"), {}, sys, ts.createSemanticDiagnosticsBuilderProgram, ()=>{}, ()=>{});
const w = ts.createWatchProgram(host);
function report(l){
  console.log("== "+l);
  console.log([...active.values()].map(([f])=>path.relative(root,f)).filter(f=>!f.startsWith("..")).sort().join("\n"));
}
function fire(name){ for (const [f,cb] of [...active.values()]) if (f.endsWith(name)) cb(f, ts.FileWatcherEventKind.Changed); }
report("initial");

fs.rmSync("proj/tsconfig.a.json"); fire("tsconfig.a.json"); fire("tsconfig.c.json"); report("a config deleted");
fs.copyFileSync("proj/a.config.bak","proj/tsconfig.a.json"); fire("tsconfig.a.json"); fire("tsconfig.c.json"); report("a config restored");
w.close();
