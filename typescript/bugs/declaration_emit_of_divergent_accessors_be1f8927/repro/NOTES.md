A JS class (checkJs, declaration emit) has a getter returning `{string}` and a setter whose param is `{URL | string}`.
Clean build emits `set path(path: URL | string);` in the .d.ts.
Injected build uses the read type and emits `set path(path: string);`.
