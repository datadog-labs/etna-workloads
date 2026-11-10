Input declares a mapped type over `T extends [...any]` and uses it as a rest parameter type.
Clean: no diagnostics (any spread becomes a rest element, so the type is an array).
Injected: error TS2370 "A rest parameter must be of an array type." and nonzero exit.
