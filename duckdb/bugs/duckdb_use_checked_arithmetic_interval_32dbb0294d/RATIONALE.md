# Rationale

## Hunk: src/common/types/interval.cpp, Interval::TryParseInterval (`interval_parse_time` block)
Traces to the single hunk of fix 32dbb02. Today's code passed `negative` into
`Time::TryConvertInterval` and added the term via checked `IntervalTryAddition`. I reverted to the
original: convert the time without sign, do an unchecked `result.micros += time.value`, then
negate the whole accumulated `result.micros` if `negative`. This brings back the unchecked int64
overflow and the sign applying to the entire accumulation (UB at INT64_MIN, wrong results for
'1 hour -00:30:00').

## Oracle result
```
CRASH    test/sql/types/interval/interval_colon_time_overflow.test
1 of 1 oracle units fail
```
(The crash is the signed-overflow sanitizer abort in the relassert build, rc=1.)
