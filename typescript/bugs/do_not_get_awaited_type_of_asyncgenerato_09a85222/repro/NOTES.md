Input is the compiler test asyncGeneratorPromiseNextType: an async generator annotated
AsyncGenerator<void, void, Promise<Result> | undefined> whose body uses `yield` and assigns the result to a Promise<Result> | undefined.
Clean: no errors (exit 0). Injected: TS2322 on the return type annotation, since TNext is wrongly awaited to Result | undefined.
