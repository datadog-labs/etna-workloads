A JS file (checkJs) defines `x.foo` via Object.defineProperty with only a setter, then writes `x.foo = 1`.
The script asks the language service for quick info at the `foo` in that write.
Clean: shows `(property) x.foo: number`. Injected: treats the write location as a setter declaration and gives a different/crashing display.
