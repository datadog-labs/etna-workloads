Input: a discriminated union (`breath: true | false`) with a user type guard `isAnimal`, and `negative(t)` returning `!isAnimal(t)`.
The compiler infers a type predicate for `negative`; the emitted .d.ts shows it.
Clean: `negative(t: Something): t is Rock`. Injected: `negative(t: Something): boolean` (the false-branch type isn't reduced to never).
