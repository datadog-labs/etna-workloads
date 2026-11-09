Input: generic `g` with a defaulted type parameter is passed to generic `f`; the result's parameter type is extracted via a conditional type and indexed with 'foo'.
Clean: compiles with no errors. Injected: error TS2536 (Type '"foo"' cannot be used to index type 'FirstParameter<...>').
