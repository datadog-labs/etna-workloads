#!/bin/bash
node "$TSC" -p . --noEmit | sed "s|$PWD|.|g"
node -e '
const ts=require(process.env.TYPESCRIPT);
const fs=require("fs");
const cwd=process.cwd();
const rel=s=>s.split(cwd).join(".");
let fileCbs=[],dirCbs=[], timers=[];
const host=ts.createWatchCompilerHost("tsconfig.json",{},{...ts.sys,
  watchFile:(f,cb)=>{fileCbs.push([f,cb]);return {close(){}}},
  watchDirectory:(p,cb)=>{dirCbs.push([p,cb]);return {close(){}}},
  setTimeout:(f)=>{timers.push(f);return timers.length},clearTimeout(){}},
  ts.createSemanticDiagnosticsBuilderProgram,()=>{},()=>{});
host.afterProgramCreate=b=>{
  console.log("program:");
  for(const d of b.getSemanticDiagnostics()) console.log(rel(ts.flattenDiagnosticMessageText(d.messageText,"\n")));
};
const p=ts.createWatchProgram(host);
const A="node_modules/@types/bar/index.d.ts",B="node_modules/foo/index.d.ts";
const dts=n=>"export declare const "+n+": number;";
const steps=[
 [A,()=>fs.unlinkSync(A)],
 [B,()=>fs.unlinkSync(B)],
 [A,()=>fs.writeFileSync(A,dts("bar"))],
 [B,()=>fs.writeFileSync(B,dts("foo"))],
];
for(const [f,st] of steps){
  console.log("--- step");
  st();
  for(const [d,cb] of dirCbs) cb(cwd+"/"+f);
  timers.splice(0).forEach(f=>f());
  timers.splice(0).forEach(f=>f());
}
p.close();
'
