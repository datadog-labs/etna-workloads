Reproducer: gets FORWARDREF-format annotations for `f(x: Annotated[undefined, ''])`.
Clean: result is a partially evaluated Annotated (get_origin is Annotated, `__origin__` is a ForwardRef, `__metadata__ == ('',)`).
Buggy: `_is_unpacked_typevartuple` is truthy for the ForwardRef proxy, so the result is a bare ForwardRef; `x.__origin__` raises AttributeError.
