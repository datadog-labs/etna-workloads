Reproducer: annotation `undef1[str, undef2]` with undefined names, fetched in STRING and FORWARDREF formats; then the ForwardRef is evaluated with globals.
Buggy interpreter drops extra names from tuple subscript elements (injection), so the result differs (error / wrong value instead of `dict[str, float]`).
