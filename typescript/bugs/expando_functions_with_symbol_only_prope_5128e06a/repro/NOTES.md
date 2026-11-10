Input: a function `inner` gets a symbol-keyed expando property (`inner[symb] = true`) and is returned as an interface requiring `[symb]`.
Clean: compiles with no errors, exit 0.
Injected: reports TS7053 on `inner[symb]` and TS2741 on `return inner`, exit 2.
