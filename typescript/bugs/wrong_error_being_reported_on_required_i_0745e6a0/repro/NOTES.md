Input: a class with a constructor parameter property that has an initializer followed by a required parameter, compiled with --isolatedDeclarations.
Clean: error TS9025 (requires implicitly adding undefined) at the parameter (4,5).
Injected: error TS9011 (Parameter must have an explicit type annotation) at the initializer (4,24).
