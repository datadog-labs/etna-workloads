Input: a generic class intersected with a generic function, aliased via instantiation expressions (`typeof Err<U>`), then a type assertion between two instantiations.
Clean: tsc compiles it and reports the expected result.
Injected: instantiation-expression types lack a symbol, so signature relation comparison behaves differently and the output (diagnostics/crash) differs.
