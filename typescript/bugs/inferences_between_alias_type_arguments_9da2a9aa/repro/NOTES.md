Input: an aws-lambda-style `Handler<TEvent = any, TResult = any>` alias with defaults, used bare and with explicit args
inside conditional types (`T extends Handler<any, infer R>`), imported across modules via node_modules `.d.ts` files.
The script prints the resolved types of `Actual` and `Expected` via the API.
Clean: `Actual` = `VerifierFn<string> | VerifierFn<Error> | VerifierFn<any>`; injected: `Actual` = `VerifierFn<unknown>`
(alias type arguments with defaults are no longer filled in during inference/variance comparison).
