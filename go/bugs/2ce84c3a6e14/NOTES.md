repro.go assigns T{} to interface I (method M) where T only has a lowercase `m` declared *after* the use.
missingMethod finds the wrong-case method `m` and formats it in the error message, which requires its signature to be type-checked.
Clean: normal "missing method M / have m() / want M()" error. Buggy (objDecl removed): internal compiler error, panic "interface conversion: syntax.Type is nil, not *types2.Signature".
