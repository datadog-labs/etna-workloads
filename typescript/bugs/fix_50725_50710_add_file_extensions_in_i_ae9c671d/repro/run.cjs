const ts=require(process.env.TYPESCRIPT);
const files={"/tsconfig.json":"{}","/src/person.ts":"export const name = 0;","/src/index.ts":'import {name} from "./person.js";'};
const opts={module:ts.ModuleKind.Node16,moduleResolution:ts.ModuleResolutionKind.Node16,rootDirs:["/src"]};
const host={getScriptFileNames:()=>["/src/person.ts","/src/index.ts"],getScriptVersion:()=>"1",
getScriptSnapshot:f=>files[f]!==undefined?ts.ScriptSnapshot.fromString(files[f]):undefined,
getCurrentDirectory:()=>"/",getCompilationSettings:()=>opts,getDefaultLibFileName:()=>"/lib.d.ts",
fileExists:f=>f in files,readFile:f=>files[f],useCaseSensitiveFileNames:()=>true};
const ls=ts.createLanguageService(host);
const r=ls.getEditsForFileRename("/src/person.ts","/src/vip.ts",{},{});
console.log(JSON.stringify(r.map(c=>c.textChanges.map(t=>t.newText))));
