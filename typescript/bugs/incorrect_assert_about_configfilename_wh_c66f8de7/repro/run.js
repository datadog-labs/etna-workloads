const ts = require(process.env.TYPESCRIPT);
const host = ts.createWatchCompilerHost(["main.ts"], {noEmit:true}, ts.sys, ts.createEmitAndSemanticDiagnosticsBuilderProgram, d=>console.log("diag", d.code), ()=>{}, [{path:"./ref"}]);
try {
  const w = ts.createWatchProgram(host);
  console.log("created", w.getProgram().getSourceFiles().length > 0);
  w.close();
} catch (e) { console.log("error:", String(e.message).split("\n")[0]); }
process.exit(0);
