import {createRequire} from 'module';
const ts=createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text=`declare namespace JSX { interface IntrinsicElements { div: { a: string, b: string } } }
const value = "test";
<div a={v} />`;
const pos=text.indexOf("{v")+2;
const host={getScriptFileNames:()=>["a.tsx"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f=="a.tsx"?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({jsx:ts.JsxEmit.React}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:f=>f=="a.tsx",readFile:f=>f=="a.tsx"?text:undefined};
const ls=ts.createLanguageService(host);
const c=ls.getCompletionsAtPosition("a.tsx",pos,{includeCompletionsWithSnippetText:true,includeCompletionsWithInsertText:true,jsxAttributeCompletionStyle:"auto"});
console.log(c.entries.filter(e=>e.name=="value"||e.name=="a"||e.name=="b").map(e=>e.name+":"+e.kind+":"+e.insertText).join("\n"));
