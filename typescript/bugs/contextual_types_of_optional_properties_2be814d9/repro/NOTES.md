Input calls generic `match<T>(cb)` inside an optional property `{ y?: number }` and an optional tuple element `[number?]`, with strict + exactOptionalPropertyTypes.
Clean: no errors (the contextual type drops the missing type, so T infers `number`).
Injected: contextual type keeps the "missing" undefined, so T is `number | undefined`, giving TS2379/TS2345 and TS18048 "'y' is possibly 'undefined'".
