const ts=require(process.env.TYPESCRIPT);
const text=`function foo() {
const a = <ns: foobar   x : test1   x :test2="string"  x:test3={true?1:0}  />;
return a;
}`;
const f="file.tsx";
const host={getScriptFileNames:()=>[f],getScriptVersion:()=>"1",getScriptSnapshot:n=>n===f?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({jsx:1}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:n=>n===f,readFile:n=>n===f?text:undefined};
const ls=ts.createLanguageService(host);
const edits=ls.getFormattingEditsForDocument(f,ts.getDefaultFormatCodeSettings("\n"));
let out=text;
for(const e of edits.slice().sort((a,b)=>b.span.start-a.span.start))out=out.slice(0,e.span.start)+e.newText+out.slice(e.span.start+e.span.length);
console.log(out);
