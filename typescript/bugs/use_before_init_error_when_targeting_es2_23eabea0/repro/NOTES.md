Input: a class with a parameter property `foo` whose instance field `baz = this.foo` is declared after the constructor, compiled with --target es2022 --useDefineForClassFields.
Clean: reports TS2729 "Property 'foo' is used before its initialization" (parameter properties are initialized after field initializers under define semantics).
Injected: only treats target ESNext as affected, so no error is reported for ES2022.
