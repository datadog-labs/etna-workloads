import {createRequire} from 'module';
const require=createRequire(import.meta.url);
const ts=require(process.env.TYPESCRIPT);
const sf=ts.createSourceFile("a.ts","/** See {@link bar} here */\nfunction foo() {}\n",ts.ScriptTarget.Latest,true);
const doc=sf.statements[0].jsDoc[0];
console.log(JSON.stringify(ts.getTextOfJSDocComment(doc.comment)));
