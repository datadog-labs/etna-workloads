Input calls generic functions whose parameter is a key-remapping mapped type `{ [P in keyof T as P]: (value: T[P], prop: P) => void }`, with arrow function properties needing contextual typing.
Clean: only the expected TS2353/TS7006 errors on the last call (foo not in filtered type).
Injected: identity `as P` remapping is treated as filtering, so callbacks lose contextual types and extra implicit-any TS7006 errors appear (lines 12, 13, 28).
