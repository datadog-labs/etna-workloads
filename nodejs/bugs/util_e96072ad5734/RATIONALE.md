# Rationale
Bug: util.inspect of an Error whose `name` is a non-string (e.g. a RegExp, number) coerced it with String(), so the output lost the constructor info (`404: foo` instead of `404 [RangeError]: foo`) and a non-string name was hidden/handled via string-only logic (the upstream crash with regex names).

Changes (all in lib/internal/util/inspect.js):
- formatError: `name ??= 'Error'` -> `name = name != null ? String(name) : 'Error'` (fix hunk: `const name = err.name != null ? err.name : 'Error'`, reversed).
- improveStack: removed the `typeof name !== 'string'` block that appends `[Constructor]` (fix hunk adding it); also removed the now-unused StringPrototypeReplace import.
- formatError key-hiding: `typeof name !== 'string' || StringPrototypeIncludes(stack, name)` -> `StringPrototypeIncludes(stack, name)` (fix hunk in removeDuplicateErrorKeys, re-expressed for today's inlined code).

Failing: parallel/test-util-inspect: `The name set to 404 did not result in the expected output "404 [RangeError]: foo", got "404: foo"`.
