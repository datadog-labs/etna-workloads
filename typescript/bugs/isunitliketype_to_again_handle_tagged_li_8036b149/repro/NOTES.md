Input narrows a union `'left' | ('right' & {right:'right'})` via `===` checks against string literals, then passes the remainder to a `never` parameter.
Clean: no errors (value narrows to never). Injected: error that type `Right` isn't assignable to `never`, since isUnitLikeType no longer treats tagged literal intersections as unit types.
