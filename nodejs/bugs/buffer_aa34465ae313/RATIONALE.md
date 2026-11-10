# Re-introduced bug: missing type check in bidirectionalIndexOf (nodejs/node#32753)

**Bug.** `bidirectionalIndexOf` in lib/buffer.js did not validate that `buffer` is a Buffer/TypedArray/DataView. Calling `Buffer.prototype.lastIndexOf` with an invalid `this` (e.g. `new Buffer.prototype.lastIndexOf(1, 'str')`) passed a non-buffer to the C++ binding, hitting a `CHECK` (`args[2]->IsNumber()` in SlowIndexOfNumber) and aborting the process instead of throwing ERR_INVALID_ARG_TYPE.

**Hunks.**
1. Removed `validateBuffer` from the `require('internal/validators')` destructuring, corresponding to the fix's import hunk (it would be unused).
2. Removed the `validateBuffer(buffer);` call at the top of `bidirectionalIndexOf`, corresponding to the fix's main hunk (today's signature has an extra `end` param). This restores the old unchecked behaviour. The third fix hunk (`buffer.length || buffer.byteLength`) is unchanged in the release and was part of the fix only to support DataView; left as is.

**Failing test.** `parallel/test-buffer-indexof` crashes (exit -6): `Assertion failed: args[2]->IsNumber()` at src/node_buffer.cc SlowIndexOfNumber, from the new "Avoid abort because of invalid usage" case instead of the expected ERR_INVALID_ARG_TYPE.
