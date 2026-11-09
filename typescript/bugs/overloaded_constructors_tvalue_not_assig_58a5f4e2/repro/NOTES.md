Input: a JS class `Foo` with `@template T` and a constructor marked `@overload`, then `foo = new Foo()` assigned to `Foo<number>` (checkJs, strict).
Clean: no errors (overload JSDoc signature uses the class type parameters).
Injected: TS2322 "Type 'Foo<T>' is not assignable to type 'Foo<number>'".
