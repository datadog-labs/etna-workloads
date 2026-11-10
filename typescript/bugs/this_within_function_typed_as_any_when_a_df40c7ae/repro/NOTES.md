a.js has a function declaration annotated with a JSDoc @type of a function type with a `this:` parameter; the body uses `this.test()`.
Clean: `this` is typed from the annotation -> TS2339 "Property 'test' does not exist on type '{ foo: number; }'".
Injected: `this` is not picked up -> TS2683 "'this' implicitly has type 'any'" instead.
