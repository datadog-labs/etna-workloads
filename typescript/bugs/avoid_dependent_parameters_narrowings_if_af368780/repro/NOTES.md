Input: a contextually typed callback with a rest-tuple-union signature `(...args: ["a", number] | ["b", string])`, destructured into parameters `(kind, payload)`, where one parameter is assigned to and the other is narrowed via a discriminant check.
Clean: any assignment to a sibling parameter disables dependent-parameter narrowing (isSomeSymbolAssigned), so `payload` is `string | number` and the checker reports errors.
Injected: only the parameter's own symbol is checked, so narrowing still applies and the output differs (some or all of those errors disappear).
