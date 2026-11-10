Input: a class whose base expression is a curried generic call (`Class<A>("A")({a: string}, {pretty: (a) => ...})`) with a contextually typed callback parameter referencing the class itself.
Clean: tsc reports no errors.
Injected: tsc reports TS2310 (recursively references itself as a base type) and TS2506 on `class A`, because signature comparison no longer skips identical parameter types.
