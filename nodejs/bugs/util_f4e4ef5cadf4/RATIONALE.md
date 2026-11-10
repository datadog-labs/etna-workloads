# Re-introduced bug: null prototype not detected in util.inspect

Bug: objects with a `null` prototype (Object.create(null), arrays/Sets/Maps/typed arrays/ArrayBuffers
with prototype set to null) lose the `[Foo: null prototype]` marker. getConstructorName returned an
empty string for them, like before the fix, so they print as `{}` / `[ 1, 3, 4 ]` and are
indistinguishable from ordinary objects.

Hunks (lib/internal/util/inspect.js):
1. getConstructorName: `if (firstProto === null) return null;` -> `return '';`. Corresponds to the fix's
   added `firstProto === null -> return null` block; the old code returned `''`.
2. getPrefix: the `constructor === null` "[X: null prototype]" branch (fix's added branch) is replaced by
   an old-style `constructor === ''` handling that yields `[tag] ` or `''`, i.e. no null-prototype marker.

Failing test: parallel/test-util-inspect (fails on every run). Example message:
actual: '[GeneratorFunction: 5]  [Foobar]', expected: '[GeneratorFunction (null prototype): 5] [Foobar]'
