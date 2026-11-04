# Rationale

55.2.0 already contained the fix's code, so I restored the pre-fix code by hand in `datafusion/functions/src/math/nanvl.rs`.

- **Signature** (reverses the `Signature::one_of` hunk and its imports): I removed the two `Coercible` arms that sent non-float numerics and NULL to Float64. Only `Exact(Float16,Float16)`, `Exact(Float32,Float32)` and `Exact(Float64,Float64)` remain, in that order. Integer inputs therefore coerce to Float16, the first matching arm, which rounds large integers.
- **`return_type`** (reverses the `return_type` hunk): it matches on `arg_types[0]` alone again.
- I left the `invoke_with_args` and `scalar_is_nan` refactor in place. It is behaviour-neutral for the float cases.

## Oracle failures

Both queries in `scalar.slt` fail.
- The `arrow_typeof` query returns `Float32`, `Float32` and `Float16` where `Float64` is expected, for `nanvl(1,2)`, `nanvl(1, f32)` and `nanvl(null,null)`.
- `nanvl(16777217, 1)` is rounded through Float16 or Float32, so the equality check returns false.
