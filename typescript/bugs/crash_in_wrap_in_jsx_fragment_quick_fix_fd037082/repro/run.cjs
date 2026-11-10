const ts=require(process.env.TYPESCRIPT);
const src="type Foo<T extends { x: string = a }> = T";
const host={getScriptFileNames:()=>["a.ts"],getScriptVersion:()=>"1",getScriptSnapshot:f=>f=="a.ts"?ts.ScriptSnapshot.fromString(src):undefined,getCurrentDirectory:()=>"/",getCompilationSettings:()=>({}),getDefaultLibFileName:()=>"lib.d.ts",fileExists:f=>f=="a.ts",readFile:f=>f=="a.ts"?src:undefined};
const ls=ts.createLanguageService(host);
const s=src.indexOf("{"),e=src.indexOf("}")+1;
const r=ls.getEditsForRefactor("a.ts",{indentSize:4,tabSize:4,newLineCharacter:"\n",convertTabsToSpaces:true,semicolons:"insert"},{pos:s,end:e},"Extract type","Extract to type alias",{});
console.log(r&&r.edits.map(x=>x.textChanges.map(t=>JSON.stringify(t.newText)+"@"+t.span.start+","+t.span.length).join("\n")).join("\n"));
