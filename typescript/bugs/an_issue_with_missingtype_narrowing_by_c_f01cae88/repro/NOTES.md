Input: a switch over an optional property of type "hello" | undefined, with `case undefined`, `case "hello"` and a default that passes the value to a `never` parameter (compiled with --strict --exactOptionalPropertyTypes).
Clean: the default branch narrows to never, so there are no errors (exit 0).
Injected: `case undefined` doesn't remove undefined in the default branch, so tsc reports an error that undefined isn't assignable to never (exit 2).
