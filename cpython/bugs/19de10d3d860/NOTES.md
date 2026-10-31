Reproducer: prints the data-pointer alignment (mod 8) of empty `array.array` buffers
for several typecodes, via `_testcapi.buffer_pointer_as_int`.
Clean: `[0, 0, 0, 0, 0, 0, 0]`. Buggy: `[6, 6, ...]`, because the shared empty buffer
is a plain `""` literal rather than max-aligned storage.
