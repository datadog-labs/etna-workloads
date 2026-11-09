Input destructures `const { index = 0 } = arg` and narrows a tuple union via `foo[index] === "a"`.
Clean: no narrowing (index is `number`), so `foo` stays the full union; error says type is the union.
Injected: `foo` is wrongly narrowed to `["a", string, number]`, so the diagnostic message differs.
