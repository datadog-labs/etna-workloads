Input: `type U = { u?: { v: string } }; const u: U = { u: {} };` under strict; asks the language service for code fixes at `u: {}` (error 2741).
Clean: offers "Add missing properties" with `v: ""`.
Injected: the optional property's contextual type includes undefined (not made non-nullable), so no fix is offered (0 fixes).
