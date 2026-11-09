index.js is a checked JS class with a late-bound property `[kBar] = null` (JSDoc @protected, @type) plus a getter/setter `bar`.
tsc emits declarations (--declaration --emitDeclarationOnly) and prints index.d.ts, plus an exit code.
Clean: `protected [kBar]: null | string`, and `bar` typed `string | null`, no errors.
Injected: TS2687 error on `[kBar]`, and the .d.ts shows `[kBar]: any` and `bar` typed `any`.
