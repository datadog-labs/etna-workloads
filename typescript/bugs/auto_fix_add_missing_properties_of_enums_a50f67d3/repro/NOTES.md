Input declares `namespace Foo.Bar` with an enum `E` and an interface whose property is typed `E.E1`, then `const foo: Foo.Bar.Baz = {}`.
The script asks the language service for the "Add missing properties" code fix at the error span and prints the inserted text.
Clean prints `prop3: Foo.Bar.E.E1`; injected omits the namespace qualifier and prints `prop3: E.E1`.
