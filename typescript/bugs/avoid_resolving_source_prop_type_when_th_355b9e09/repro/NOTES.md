Input is the zod-like self-referential getter case (issue #61659): `const Category = object({ get parent() { return optional(Category); } })` under --strict.
Clean: no errors. Injected: TS7023 "'parent' implicitly has return type 'any'" because the source prop type is resolved even when the target is any/unknown.
