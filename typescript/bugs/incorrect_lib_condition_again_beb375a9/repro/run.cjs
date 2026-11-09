const ts=require(process.env.TYPESCRIPT);
const p=ts.createProgram(["input.ts"],{target:ts.ScriptTarget.ES2015,types:[]});
for(const f of p.getSourceFiles()) console.log(require('path').basename(f.fileName), p.isSourceFileDefaultLibrary(f));
