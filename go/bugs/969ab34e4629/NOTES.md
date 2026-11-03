repro.go declares `var ok = undef` (undefined) and then `x, ok := m[0]` (comma-ok map index).
Clean: reports both `undefined: undef` and `declared and not used: ok`.
Buggy: the comma-ok types are recorded even though the init failed, which marks `ok` as used,
so the `declared and not used: ok` error is missing (injection removes the mode != invalid guard
in initVars/assignVars from go.dev/issue/59371).
