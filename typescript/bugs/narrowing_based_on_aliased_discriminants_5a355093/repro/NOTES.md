Destructured parameter {data, ok} of a discriminated union; 'const isOk = ok; if (isOk) data.toExponential()'.
Clean: narrows data via the aliased discriminant, no errors (exit 0).
Injected: parameter bindings not treated as const-like, so error TS18048 'data' is possibly 'undefined' (exit 2).
