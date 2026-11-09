The input is a nested call `createMachine({on:{FOO: raise(({event}) => ({type:"BARx" as const}))}})`.
The script asks the language service for string-literal completions inside the nested call, then asks for semantic diagnostics.
Clean: reports the TS2322 error (`"BARx"` not assignable to `"BAR"`). Injected: the completion request leaves cached function types behind, so the error is missing.
