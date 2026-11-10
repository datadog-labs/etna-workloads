#!/bin/bash
cat > show.cjs <<'J'
const ts = require(process.env.TYPESCRIPT);
const p = ts.createProgram(["input.ts"], {strict:true,noEmit:true,target:ts.ScriptTarget.ES2015});
const c = p.getTypeChecker();
const sf = p.getSourceFile("input.ts");
const d = sf.statements[sf.statements.length-1].declarationList.declarations[0];
console.log(c.typeToString(c.getTypeAtLocation(d.name)));
J
node show.cjs
