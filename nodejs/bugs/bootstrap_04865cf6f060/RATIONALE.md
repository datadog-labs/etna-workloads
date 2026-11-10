# Rationale

**Bug:** With `--frozen-intrinsics`, `enableDerivedOverride` replaces data properties (e.g. `Object.prototype.toString`) with accessors whose setter lets derived objects assign. The setter created the own property on the derived object copying `desc.enumerable`/`desc.configurable` from the original (non-enumerable) builtin, so `o.toString = ...` produced a non-enumerable own property instead of a normal enumerable, configurable one.

**Change (lib/internal/freeze_intrinsics.js, setter in `enableDerivedOverride`):** `enumerable: true, configurable: true` -> `enumerable: desc.enumerable, configurable: desc.configurable`. This reverses the single hunk of the fix (the code now uses `ObjectDefineProperty` with `__proto__: null`, but is otherwise the same).

**Failing test:** `parallel/test-freeze-intrinsics` — `not ok`, assertion on `Object.getOwnPropertyDescriptor(o, 'toString').enumerable`: actual: false, expected: true. Stable across two runs.
