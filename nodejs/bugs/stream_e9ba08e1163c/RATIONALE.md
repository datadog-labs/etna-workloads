# Re-introduced bug: web streams Symbol.toStringTag is an own-instance getter, not a prototype data property

**Bug.** Web stream classes defined `get [SymbolToStringTag]() { return this[kType]; }` as a getter in the class body. The fix replaced it with a non-writable, configurable data property on the prototype whose value is the class name. With the bug, `Cls.prototype[Symbol.toStringTag]` is `undefined`, because the getter reads `this[kType]` and `kType` is only set on instances. The descriptor is also an accessor, not a data property.

**Hunks** (each corresponds to the fix's per-file hunks, re-expressed for today's code, where the helper `getNonWritablePropertyDescriptor` now lives in `util.js`):
- `readablestream.js`: removed the `[SymbolToStringTag]: getNonWritablePropertyDescriptor(X.name)` entries from the `ObjectDefineProperties` calls. Added the getter back to ReadableStream, ReadableStreamBYOBRequest, ReadableStreamDefaultReader, ReadableStreamBYOBReader, ReadableStreamDefaultController and ReadableByteStreamController. It returns `this[kType]`.
- `writablestream.js`: the same change for WritableStream, WritableStreamDefaultWriter and WritableStreamDefaultController.
- `transformstream.js`: the same change for TransformStream and TransformStreamDefaultController.
- `queuingstrategies.js`: the same change for ByteLengthQueuingStrategy and CountQueuingStrategy. These classes no longer have `kType` today, so the getter returns the literal class name. It is still an accessor, so the descriptor check fails.

The `ReadableStream AsyncIterator` entry was not part of the fix, so I left it alone. The `getNonWritablePropertyDescriptor` imports are now unused in the four modified files (a lint-only issue).

**Failing test.** `parallel/test-webstream-string-tag` fails on the first class tested, `WritableStream`. The assertion `cls.prototype[Symbol.toStringTag] === cls.name` reports `actual: undefined, expected: 'WritableStream'`. I ran it twice and it failed both times.
