const ts=require(process.env.TYPESCRIPT);const fs=require('fs');
const text=fs.readFileSync('input.ts','utf8');
const opts={target:ts.ScriptTarget.ES2022,module:ts.ModuleKind.ESNext};
const host={getScriptFileNames:()=>['input.ts'],getScriptVersion:()=>'1',getScriptSnapshot:f=>f==='input.ts'?ts.ScriptSnapshot.fromString(text):undefined,getCurrentDirectory:()=>'.',getCompilationSettings:()=>opts,getDefaultLibFileName:()=>'lib.d.ts',fileExists:f=>f==='input.ts',readFile:f=>f==='input.ts'?text:undefined};
const ls=ts.createLanguageService(host);
const pos=text.indexOf('    \n}')+4;
const r=ls.getCompletionsAtPosition('input.ts',pos,{includeCompletionsWithInsertText:true,includeCompletionsWithClassMemberSnippets:true,includeCompletionsWithSnippetText:true});
console.log(r.entries.filter(e=>e.name.includes('SOME')).map(e=>e.name+' | '+e.insertText).join('\n')||'none');
