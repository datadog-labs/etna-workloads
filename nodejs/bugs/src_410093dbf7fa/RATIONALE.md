# Re-introduced bug: union type-punning in trace values

**Bug.** `SetTraceValue(bool, ...)` stored the bool into a `TraceValueUnion` (`as_bool`) and read back `as_uint`. Only the first byte of the union is initialized, so the other 7 bytes of the resulting `uint64_t` are indeterminate stack garbage (reading an inactive union member). Trace args of type bool therefore got garbage in their upper bits.

**Hunks (all in `src/tracing/trace_event_legacy_inl.h`).**
1. Re-added the `TraceValueUnion` definition (fix removed it).
2. Replaced the memcpy-based `INTERNAL_DECLARE_SET_TRACE_VALUE` (which zeroes `*value` first) with the old union-based macro, re-adding the `bool` overload through it, along with the double, pointer, string and copy-string overloads. The generic integral/enum template added by the fix is kept, because the new test uses an enum and would not compile without it. A non-template `bool` overload wins overload resolution over the template, so bool goes through the union.

**Failing test.** `cctest TraceEvent.SetIntegralTraceValue`:
```
test_trace_event.cc:31: Failure
Expected equality of these values:
  uint64_t{0}
  value   Which is: 9291556815508000512
```
`TraceEvent.SetNonIntegralTraceValue` still passes. Rerun twice and the failure was stable.
