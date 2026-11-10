Input: a.ts exports Bar/Baz; b.ts imports them and defines `const Foo = {bar: Bar, baz: Baz}` used by `fn`. run.js asks the language service for "Move to file" of Foo into a.ts.
Clean: a.ts gets Foo without a self-import, and b.ts imports Foo from ./a.
Injected: existing locals miss Bar/Baz, so the edit to a.ts adds a self-import (`import { Bar, Baz } from "./a"`).
