const ts = require(process.env.TYPESCRIPT);
const p = ts.createProgram(["input.ts"], {});
const c = p.getTypeChecker();
const sf = p.getSourceFile("input.ts");
const fn = sf.statements[0];
console.log(c.typeToString(c.getTypeAtLocation(fn.parameters[0].name)));
