# Rationale

Fix #12751 gave `strpos` a strict string-only signature (`Signature::string(2)`), so
non-string input such as `position(1 in 1)` is a planning error. Before the fix,
`strpos` used a loose signature and silently accepted integers.

In 55.2.0 the equivalent of `Signature::string` is `Signature::coercible` with
`Coercion::new_exact(logical_string())`. I reverted only that part of the `strpos`
hunk, in `datafusion/functions/src/unicode/strpos.rs`. Each argument now uses
`Coercion::new_implicit(logical_string(), [Any], NativeType::String)`, so any type is
cast to string. This is the same pattern `reverse` uses. It restores the pre-fix
behaviour: non-string input is accepted instead of rejected.

I did not touch the other hunks (the `TypeSignature::String` plumbing and the
per-function signature changes). They are infrastructure, and no clearly
equivalent defect exists for them in 55.2.0.

## Oracle failures
- `scalar.slt`: `query error ... select position(1 in 1)` is expected to fail but
  succeeds (scalar.slt:2309).
- `string_view.slt`: still passes.
