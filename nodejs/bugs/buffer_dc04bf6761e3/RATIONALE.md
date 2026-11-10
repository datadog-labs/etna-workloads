# Bug
Buffer.prototype methods relied on prototype-bound helpers (`this.utf8Slice`, `this.utf8Write`, ...), so calling them with a plain Uint8Array as `this` (e.g. `Buffer.prototype.toString.call(u8)`) throws `TypeError: this.utf8Slice is not a function`.

# Changes (lib/buffer.js only)
The release already has the static-function forms in lib/internal/buffer.js and src/node_buffer.cc (they still work for `Buffer`s); I reverted only the call sites, matching the fix's lib/buffer.js hunks:
- `toString()` (no args and `encoding === undefined` paths): `utf8Slice(this, ..)` -> `this.utf8Slice(..)` (fix hunks in toString).
- inspect: `hexSlice(this, 0, n)` -> `this.hexSlice(0, n)`.
- `write()`: `utf8Write(this, ..)` / `asciiWrite(this, ..)` -> `this.utf8Write(..)` / `this.asciiWrite(..)` (fix hunks in write).

# Failing test
parallel/test-buffer-generic-methods: `TypeError: this.utf8Slice is not a function`. test-buffer-write-fast still passes.
