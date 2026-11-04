# Rationale

Fix (#12712) replaced strpos's `Signature::user_defined` + custom `coerce_types`
with an explicit `one_of(Exact...)` signature. In 55.2.0 the signature is
`Signature::coercible(logical_string x2)`, which is the descendant of that fix.

Change, in `datafusion/functions/src/unicode/strpos.rs` (single hunk, reverses
the whole fix hunk set for this file):
- `StrposFunc::new` uses `Signature::user_defined(Volatility::Immutable)` again.
- The removed `coerce_types` is restored verbatim. Its `(_, Null)` arm returns
  `[first, Utf8]`, so a Dictionary haystack with a NULL needle is not unwrapped,
  and its fallback arm plan-errors on non-string args (e.g. `position(1 in 1)`).
- Imports adjusted (`plan_err` added; unused `logical_string`/`Coercion`/
  `TypeSignatureClass` removed).

Oracle cases expected to fail: `scalar.slt` `select position(1 in 1)` (now a
plan error instead of `1`) and `functions.slt`
`strpos(arrow_cast(..., 'Dictionary(Int32, Utf8)'), NULL)` (dictionary reaches
invoke unsupported).
