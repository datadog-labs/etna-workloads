A generic function declares a type argument `Values<{ [K in keyof TActors as K & string]: {...} }>`, where `Values<T> = T[keyof T]`, and checks it against the constraint `ProvidedActor` (`src: string`).
Clean: no diagnostics, exit 0.
Injected: reports TS2344, because `keyof` of the remapped mapped type is no longer simplified and is treated as `string | number | symbol`.
