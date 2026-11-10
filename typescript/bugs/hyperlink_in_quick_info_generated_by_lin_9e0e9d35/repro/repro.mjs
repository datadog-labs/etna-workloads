import {createRequire} from 'module';
const ts=createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files={"/a.ts":"export function B() { }\n","/b.ts":'import { B } from "./a";\n/**\n * {@link B}\n */\nexport function f() { }\n'};
const opts={module:ts.ModuleKind.CommonJS};
const host={getScriptFileNames:()=>Object.keys(files),getScriptVersion:()=>"1",getScriptSnapshot:n=>files[n]!==undefined?ts.ScriptSnapshot.fromString(files[n]):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>opts,getDefaultLibFileName:()=>"/lib.d.ts",fileExists:n=>n in files,readFile:n=>files[n]};
const ls=ts.createLanguageService(host);
const pos=files["/b.ts"].indexOf("function f")+9;
const qi=ls.getQuickInfoAtPosition("/b.ts",pos);
for(const d of qi.documentation) console.log(d.kind, JSON.stringify(d.text), d.target?d.target.fileName+":"+d.target.textSpan.start:"");
