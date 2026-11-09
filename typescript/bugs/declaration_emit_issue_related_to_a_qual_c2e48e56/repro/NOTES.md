a.ts re-exports a value whose type comes from boxedBox.d.ts (an `import("./box").Box<{boxed: import("./box").Box<number>}>` type), with a comment at a position matching a node in the other file.
Declaration emit reuses the cross-file import type node.
Clean: `boxed: import("./box").Box<number>;`. Injected: the qualifier isn't visited, so a stray `/** wat */` comment is emitted inside the type (`Box /** wat */<number>`), producing an invalid .d.ts.
