# Rationale

Hunk changed: `SqlToRel::match_window_definitions` in `datafusion/sql/src/select.rs`.

It reverses the fix hunk that added `self.ident_normalizer.normalize(...)` for both
the window definition names and the `OVER <name>` reference. In 55.2.0 the function
is still a method, so I removed the normalized `Vec` of definitions and the
`normalized_ident`. It now compares the raw `Ident`s (`ident.eq(window_ident)`),
as the pre-fix code did. The in-loop `if let Some(WindowType::NamedWindow(ident)) = &f.over`
re-borrow is kept because the borrow checker requires it. Behaviour matches pre-fix.

Result: unquoted window names that differ only in case (`OVER W` vs `WINDOW w`) no
longer match, so planning fails with "The window W is not defined!".

Failing oracle cases (window.slt, both new "window definitions with aliases" queries):
- `SUM(t1.v1) OVER W + 1 ... WINDOW w AS (...)` -> "The window W is not defined!"
- `SUM(t1.v1) OVER w + 1 ... WINDOW W AS (...)` -> "The window w is not defined!"
