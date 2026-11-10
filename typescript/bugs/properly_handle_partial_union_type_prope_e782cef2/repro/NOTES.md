Input: generic functions `T extends any[] | Record<string, any>` that narrow `obj` with `'length' in obj` (and `Array.isArray(obj) || 'length' in obj`); the script prints the type of `obj` in the else branch via the API.
Clean: `T` (the `length` property is only partially present in the union, so absence is still possible).
Injected: `never`, because isTypePresencePossible ignores the Partial check flag.
