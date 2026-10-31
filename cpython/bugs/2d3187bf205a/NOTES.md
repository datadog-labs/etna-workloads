Reproducer: with `from __future__ import annotations`, a module-level class `T` clashes with
the PEP 695 type parameter `T` of `def f[T](x: T)`. `get_type_hints(f)["x"]` should be the
type parameter (prints True on clean). The injected bug in `typing._add_type_params_to_scope`
lets the globals win over the type params, so buggy resolves `T` to the global class (prints False).
