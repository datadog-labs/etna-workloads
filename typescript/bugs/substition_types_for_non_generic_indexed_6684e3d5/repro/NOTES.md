Input: `interface A {}` and `type B = A extends Record<'foo', string> ? A['foo'] : string;`.
Clean: no errors (A['foo'] is valid via the substitution type in the true branch), exit 0.
Injected: non-generic substitution type is dropped, so error TS2339 "Property 'foo' does not exist on type 'A'" is reported, exit 2.
