Input: `options?.a === false || options.b` where `options` is an optional parameter, compiled with --strict.
Clean: narrowing by `=== false` on an optional chain doesn't remove undefined in the `||` right operand, so it reports TS18048 "'options' is possibly 'undefined'".
Injected: the boolean-comparison narrowing wrongly applies to access expressions, so `options` is treated as defined and no error is reported.
