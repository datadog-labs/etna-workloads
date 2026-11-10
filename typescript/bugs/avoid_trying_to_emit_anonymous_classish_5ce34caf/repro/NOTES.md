file.js declares const-assigned anonymous function expressions with `this.x` members and expando statics (e.g. `SomeConstructor3.staticMember = "str"`), compiled with `--allowJs --checkJs --declaration --emitDeclarationOnly`.
Clean: the .d.ts serializes them as functions/namespaces (`declare function SomeConstructor3(): void; ...`).
Injected: they are emitted as `declare var X: { new(): ...}` assignment forms and an unreachable-anonymous-type error is reported, so output and exit status differ.
