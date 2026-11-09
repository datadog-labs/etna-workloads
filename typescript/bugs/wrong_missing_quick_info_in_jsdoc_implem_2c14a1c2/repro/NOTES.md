a.js defines a JSDoc `@typedef Foo`; b.js imports it as `_a` and uses `@implements {_a.Foo}` on a class.
The script asks the language service for quick info on `Foo` in the tag.
Clean: `type: type Foo = {...}`. Injected: the tag's type name isn't treated as a type node, so quick info is `any` with an empty kind.
