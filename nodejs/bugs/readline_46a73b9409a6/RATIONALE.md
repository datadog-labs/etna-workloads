# Rationale

**Bug:** `_getDisplayPos` counted every newline-terminated line as exactly one row, even when the line was wider than the terminal and wrapped. Multi-line prompts with wide lines therefore gave a wrong cursor row count, and `_refreshLine` cleared too few lines (duplicating prompt lines on e.g. backspace).

**Change (lib/internal/readline/interface.js, `[kGetDisplayPos]`):** corresponds to the single lib/readline.js hunk of the fix. In the `'\n'` branch, `rows += MathCeil(offset / col) || 1;` (plus its comment) is replaced by `rows += 1;`, restoring the pre-fix behaviour of ignoring wrapping. The `offset` reset line is untouched (it was refactored since the fix).

**Failing test:** `parallel/test-readline-interface` ("Multi-line prompt cursor position"): `actual: 3, expected: 4` (cursorPos.rows). Failure was stable across runs.
