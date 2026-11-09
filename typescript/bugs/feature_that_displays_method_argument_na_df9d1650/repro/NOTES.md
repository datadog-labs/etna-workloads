Input: two overloads of `func`; only the second accepts the multi-line call `func({n:[1,2,3]}, {id:1})`.
Language-service parameter-name inlay hints are printed.
Clean: hints use the resolved overload's names (`ok_1:`, `ok_2:`).
Injected: hints use the first overload's names (`bad1:`, `bad2:`).
