Input a.js: JS class A with a documented method, and class B extends A using `/** @extends {A<number>} */` that overrides `method` without docs.
repro.mjs asks the language service for quick info on `b.method`.
Clean: quick info includes "Method documentation." inherited from A.
Injected: the @extends tag is not treated as a heritage expression, so the inherited documentation is missing.
