input.ts uses a private field `x.#foo` inside a class decorator expression, outside the class body (`@dec((x: B) => x.#foo) class B { #foo }`).
Clean tsc reports an error (private identifier not accessible outside class body, since decorators are excluded from the class scope).
Injected tsc treats the decorator as inside the class and reports no error.
