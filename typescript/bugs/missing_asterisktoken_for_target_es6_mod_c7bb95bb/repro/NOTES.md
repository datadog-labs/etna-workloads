Input exports a generator function (`export function* gen`) compiled with target=es2015, module=amd.
Clean emits `function* gen()`; injected drops the asterisk, emitting `function gen()` with a `yield` (broken JS).
