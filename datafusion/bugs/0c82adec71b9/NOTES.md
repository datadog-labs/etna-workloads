Reproducer: two single-row struct tables with the same field names in different order (`{a: 1, b: 'x'}` vs `{b: 'y', a: 2}`).

Type coercion of struct types should match fields by name (fix #19674). The injection removes that, so coercion is positional.

- clean: the UNION's type is `Struct("a": Int64, "b": Utf8)`, and `t1.s = t2.s` returns `false`.
- buggy: the UNION's type is `Struct("a": Utf8, "b": Utf8)`, and `t1.s = t2.s` fails with `Cannot cast string 'x' to value of Int64 type`.
