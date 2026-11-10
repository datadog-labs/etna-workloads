import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const p = ts.createProgram(["input.ts"], { strict: true, noEmit: true });
const c = p.getTypeChecker(), sf = p.getSourceFile("input.ts");
function v(n) {
  if (ts.isExpressionStatement(n) && ts.isIdentifier(n.expression))
    console.log(sf.getLineAndCharacterOfPosition(n.pos).line + 1, c.typeToString(c.getTypeAtLocation(n.expression)));
  ts.forEachChild(n, v);
}
v(sf);
