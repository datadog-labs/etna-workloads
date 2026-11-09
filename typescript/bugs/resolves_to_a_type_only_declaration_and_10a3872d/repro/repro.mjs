import {createRequire} from 'module';
const ts=createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files={"/a.ts":"export function f() {}\n","/b.ts":'export type * as b from "./a.js";\n',"/c.ts":'import { b } from "./b.js";\n'};
const opts={verbatimModuleSyntax:true,module:ts.ModuleKind.ESNext,moduleResolution:ts.ModuleResolutionKind.Bundler,target:ts.ScriptTarget.ESNext};
const host={getScriptFileNames:()=>Object.keys(files),getScriptVersion:()=>"1",getScriptSnapshot:f=>files[f]!==undefined?ts.ScriptSnapshot.fromString(files[f]):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>opts,getDefaultLibFileName:()=>"/lib.d.ts",fileExists:f=>f in files,readFile:f=>files[f],};
const ls=ts.createLanguageService(host);
const d=ls.getSemanticDiagnostics("/c.ts");
for(const x of d){console.log(x.code,ts.flattenDiagnosticMessageText(x.messageText,"\n"));
const fx=ls.getCodeFixesAtPosition("/c.ts",x.start,x.start+x.length,[x.code],{},{});
console.log(fx.map(f=>f.description+" => "+f.changes.map(c=>c.textChanges.map(t=>t.newText).join("|")).join(";")));}
