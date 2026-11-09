input.ts passes `Identity<UnboxArray<T>>` (nested homomorphic mapped types over `T extends Array<Box<string>>`) to a `Test<T extends string[]>` constraint.
Clean: no diagnostics, since the nested mapped type's apparent type resolves through the array constraint.
Injected: reports TS2344 "Type 'Identity<UnboxArray<T>>' does not satisfy the constraint 'string[]'", because the nested mapped type constraint isn't resolved recursively.
