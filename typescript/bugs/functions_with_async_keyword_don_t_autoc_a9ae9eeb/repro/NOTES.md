Input: an object literal typed `T` (with method `foo`) containing the partial member `async f`; the script requests completions after `f` via the language service.
Clean: completions include `foo` (object-literal member completion after `async`).
Injected: `foo` is missing, so the script prints "no foo".
