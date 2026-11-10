Input: a const initialized via a generic call whose object literal property uses an `as Wrapper<"hello">` assertion; the exported type is derived through a conditional type (`Unwrap`).
Declaration emit (`--declaration --emitDeclarationOnly`) of `unwrapped`.
Clean: `export declare const unwrapped: { prop1: "hello"; };`.
Injected: reuses the assertion node, emitting `prop1: Wrapper<"hello">` plus a `Wrapper` type alias and `export {}`.
