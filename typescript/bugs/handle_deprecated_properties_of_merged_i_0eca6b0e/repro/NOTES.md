Input merges two `interface I` declarations; only the first declares `x` with `@deprecated`, then `i.x` is accessed.
Clean: reports a deprecation suggestion diagnostic (6385) for `x` (some declaration deprecated on merged interfaces).
Injected: requires every declaration to be deprecated, so no suggestion is reported.
