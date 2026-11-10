#!/bin/bash
cat > decl.ts <<'X'
declare const a: string[] | [string];
export const f = a.every;
X
node -e '
const ts=require(process.env.TYPESCRIPT);
const p=ts.createProgram(["decl.ts"],{strict:true,noEmit:true});
const c=p.getTypeChecker();const sf=p.getSourceFile("decl.ts");
const d=sf.statements[1].declarationList.declarations[0];
console.log(c.typeToString(c.getTypeAtLocation(d.name),sf,ts.TypeFormatFlags.NoTruncation|ts.TypeFormatFlags.GenerateNamesForShadowedTypeParams));
'
