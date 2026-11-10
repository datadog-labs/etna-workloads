import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const p = ts.createProgram(['input.ts'], {});
const c = p.getTypeChecker();
const sf = p.getSourceFile('input.ts');
(function walk(n){
  if (ts.isIdentifier(n) && n.parent.kind === ts.SyntaxKind.ExpressionWithTypeArguments) {
    const s = c.getSymbolAtLocation(n);
    console.log(n.text, '->', s ? s.name : 'undefined');
  }
  ts.forEachChild(n, walk);
})(sf);
