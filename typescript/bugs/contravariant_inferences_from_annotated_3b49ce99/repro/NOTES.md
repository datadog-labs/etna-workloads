input.ts calls a generic `filter<T>(predicate: (value: T, index: number) => boolean): T` with an annotated optional parameter `(pose?: number) => true`, then assigns the result to `number`.
Clean: T is inferred as `number | undefined`, so the assignment errors (TS2322) and exit=2.
Injected: optionality is dropped, T is inferred as `number`, so there is no error and exit=0.
