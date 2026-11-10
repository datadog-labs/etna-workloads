Input: a function with `this: CorrectObject | WrongObject` narrowed by a type guard `isCorrect(this)`, then an arrow callback using `this.name`.
Clean: no diagnostics (narrowing of `this` flows into the arrow function), exit 0.
Injected: error TS2339 "Property 'name' does not exist on type 'WrongObject | CorrectObject'", exit 2.
