Input: an ES5-targeted `for (let x of [])` loop whose body is captured by a closure and contains a labeled empty declaration (`foo: var;`).
Clean: compiles and emits JS (the labeled statement becomes `foo: ;`).
Injected: the converted-loop transform hits `Debug.checkDefined` on the emptied labeled statement and tsc crashes (non-zero exit, no output).
