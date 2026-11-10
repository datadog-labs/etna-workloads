const ts = require(process.env.TYPESCRIPT);
const src = `/** See {@link A#m} for details */
function f() {}
`;
const sf = ts.createSourceFile("a.ts", src, ts.ScriptTarget.Latest, true);
const doc = sf.statements[0].jsDoc[0];
console.log(ts.getTextOfJSDocComment(doc.comment));
