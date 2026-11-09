Input: a `for (const value of ...)` loop whose body captures `value` via a shorthand property `({ value })` in an arrow function, compiled with `--noCheck --target es5`.
Clean: emits a `_loop_1` function so each iteration gets its own `value`.
Injected: the shorthand-property identifier isn't treated as a captured binding, so no `_loop_1` is emitted and the closure shares one `value`.
