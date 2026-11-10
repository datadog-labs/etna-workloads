Input: an unnamed class expression with an abstract property `bar` accessed via `this.bar++` in the constructor.
Clean: reports normal diagnostics (abstract property cannot be accessed in constructor) and exits normally.
Injected: the checker dereferences the missing class name (`declaringClassDeclaration.name!`) and crashes.
