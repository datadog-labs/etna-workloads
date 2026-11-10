const ts=require(process.env.TYPESCRIPT);
const p=ts.createProgram(["input.ts"],{target:ts.ScriptTarget.ES2020,noEmit:true});
for(const f of p.getSourceFiles().filter(f=>/lib\.es5\.d\.ts$|input\.ts$/.test(f.fileName)))
 console.log(f.fileName.split("/").pop(),p.isSourceFileDefaultLibrary(f));
