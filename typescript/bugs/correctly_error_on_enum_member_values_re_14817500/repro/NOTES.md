input.ts declares a local `const Infinity = "a".length` and uses it as an enum member initializer (`X = Infinity, Y`).
Clean: the local Infinity shadows the global, so it is not a constant expression and `Y` errors (TS1061, must have an initializer).
Injected: the identifier is treated as the numeric global Infinity, so no error is reported and exit status is 0.
