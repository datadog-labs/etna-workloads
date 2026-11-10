A JS file (checkJs) has a class whose constructor assigns `this.prop = ""` and which later declares `declare prop: string;`; `q.js` loads it in-memory via the API and prints the pre-emit diagnostics.
Clean: prints the TS8009/TS8010 errors plus TS2339 (property 'foo' does not exist on type 'string') and "done".
Injected: the ambient declaration no longer takes over as valueDeclaration, so checking hits an assertion failure ("Debug Failure. False expression") in getConstructorDefinedThisAssignmentTypes, printed as "crash: ...".
