# Re-introduced bug: crash for non-number index arguments in Buffer natives

Bug: after 2555cb4a the C++ side asserted that index arguments were Numbers (`CHECK(arg->IsNumber())`) instead of coercing them, so a non-number such as `b.copy(c, 'not a valid offset')` or `b.copy(c, '0', '0', '512')` aborted the process unless JS validation happened to coerce first. The fix coerced values to integers (`IntegerValue`), propagating exceptions.

In v26.13.0 `Buffer.prototype.copy` no longer calls `ParseArrayIndex`; it coerces in `lib/buffer.js` and calls `SlowCopy`. So the reversal was re-expressed for that path.

Hunks:
1. `src/node_buffer.cc` `ParseArrayIndex`: replaces `arg->IntegerValue(env->context()).To(&tmp_i)` with `CHECK(arg->IsNumber()); arg.As<Integer>()->Value()` (reverse of the fix's ParseArrayIndex hunk; call sites keep the Maybe signature).
2. `src/node_buffer.cc` `SlowCopy`: adds `CHECK(args[2..4]->IsNumber())`, the same assertion applied to the copy native, which now takes its indices directly.
3. `lib/buffer.js` `copyImpl`: non-number targetStart/sourceStart/sourceEnd are no longer coerced with `toInteger` (only numeric non-integers are), so strings reach native code uncoerced, as before the fix (reverts the "coerce values to integers" behavior).

Failing test: `parallel/test-buffer-copy` crashes (exit -6): `Assertion failed: args[2]->IsNumber()` in `SlowCopy` (node_buffer.cc:643). Failure was stable over two runs.
