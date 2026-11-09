Input: a generic function destructures `[, ...rest]` from `["a"][][N]` (array indexed by type parameter N extends number).
The emitted .d.ts shows the inferred return type.
Clean: `=> []` (rest sliced from the base constraint tuple). Injected: `=> "a"[]` (rest treated as an array type).
