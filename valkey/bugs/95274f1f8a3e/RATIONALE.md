# Rationale

## Change: `src/t_zset.c`, `zrangeGenericCommand`, missing-source-key branch

Reverses the single implementation hunk of the fix. The fix made the
`zobj == NULL` branch go through the result handler when `store` is set
(`beginResultEmission` and `finalizeResultEmission(handler, 0)`), so
ZRANGESTORE replies 0 and deletes the destination. Otherwise it keeps
`addReply(c, shared.emptyarray)`. In 9.0.7 `beginResultEmission` takes an extra
`-1` length argument, but the logic is the same. I restored the pre-fix
unconditional `addReply(c, shared.emptyarray)`. A missing source key under
ZRANGESTORE again replies with an empty array instead of the integer 0, and
the destination key is never touched.

## Oracle cases that fail

- `ZRANGESTORE - src key missing`: the reply is an empty array, so
  `assert_equal $res 0` fails.
- `ZRANGESTORE - src key wrong type`: this follows from the first failure.
  `z2{t}` is left over from the previous test and still holds `a c d`, so the
  zrange check returns `a c d` where `a` is expected.
