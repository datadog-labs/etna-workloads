Reproducer for #23017 (map assignment order). In `m[k], *p = v, w` where `*p` panics (nil deref / index out of range),
the spec requires the map assignment (an earlier operand-order item) to have happened. Clean prints `1 42` / `1 2`;
the buggy compiler defers the map store via order.mapAssign temporaries, so the store is lost: `0 0` / `0 0`.
