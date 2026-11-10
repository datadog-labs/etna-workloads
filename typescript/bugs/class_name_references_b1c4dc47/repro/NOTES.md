Input: a legacy-decorated class (`@y(1, () => C) class C {}`) whose decorator argument references the class, compiled with target es2015 and experimentalDecorators.
Clean: emits `let C = class C {}` and `() => C` unchanged.
Injected: wrongly treats the reference as a constructor reference, emitting `var C_1; let C = C_1 = class C {}` and `() => C_1`.
