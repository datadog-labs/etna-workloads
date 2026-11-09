#!/bin/bash
cat > p.cjs <<'EOT'
const ts=require(process.env.TYPESCRIPT);
const p=ts.createProgram(['index.ts'],{target:2,noEmit:true,module:1,moduleResolution:2});
const c=p.getTypeChecker();const sf=p.getSourceFile('index.ts');
sf.statements.forEach(s=>{if(ts.isTypeAliasDeclaration(s))console.log(s.name.text,c.typeToString(c.getTypeAtLocation(s.name),undefined,ts.TypeFormatFlags.NoTruncation|ts.TypeFormatFlags.InTypeAlias))});
EOT
node p.cjs
