Input is an object literal whose properties have trailing line/block comments after the comma.
Clean tsc emits the comments (`p0: 0, // Comment 0`, multiline `/* Comment 1 ... */`) in the JS output.
Injected tsc drops the comments after `p0` and `p1`; only the last one survives.
