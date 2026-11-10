A nodenext project with allowJs-style checkJs + declaration emit (declarationDir ./types) imports itself by package name ("js-self-name-import/foo.js"), with an exports map pointing types to ./types/src/* and default to ./src/*.
Clean: the self-name import resolves back to the input JS file src/foo.js, so no error is reported.
Injected: it resolves to the output types/src/foo.d.ts instead, so tsc reports TS5055 "Cannot write file '/types/src/foo.d.ts' because it would overwrite input file".
