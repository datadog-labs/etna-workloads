repro.go declares `type T T.x`, a selector on the type being declared.
Clean toolchain: `invalid recursive type: T refers to itself` (cycle reported).
Buggy toolchain: `T.x is not a type` (the incomplete-type check in selector was removed, so the cycle goes undetected and a different error is given).
