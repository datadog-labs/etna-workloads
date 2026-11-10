Input: a class whose constructor has a parameter property with a nested array binding pattern (`public [[x]]: any[]`), compiled with `--declaration --emitDeclarationOnly`.
Clean: declaration emit completes and prints the .d.ts.
Injected: the declaration transformer does not `continue` after recursing into a nested binding pattern, so it also emits the nested pattern as a property; this changes the output/exit status (crash or wrong .d.ts).
