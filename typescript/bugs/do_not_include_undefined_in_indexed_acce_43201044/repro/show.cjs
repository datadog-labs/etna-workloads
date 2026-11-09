const ts = require(process.env.TYPESCRIPT);
const p = ts.createProgram(["input.ts"], { strict: true, noEmit: true });
const c = p.getTypeChecker();
function v(n) {
  if (ts.isVariableDeclaration(n) || ts.isBindingElement(n)) if (ts.isIdentifier(n.name)) console.log(n.name.text, c.typeToString(c.getTypeAtLocation(n.name)));
  ts.forEachChild(n, v);
}
v(p.getSourceFile("input.ts"));
