# Rationale

**Bug:** StringDecoder's UTF-16LE path passed raw (possibly unaligned) buffer data to the `uint16_t*` `StringBytes::Encode` overload, assuming 2-byte alignment (issue #22358). After an odd number of buffered bytes the decoded data pointer is unaligned. Debug builds hit an alignment CHECK. Release builds do an unaligned read.

**Change (src/string_decoder.cc, `MakeString`):** In the fix, the `UCS2` special case in `MakeString` is removed and the generic `StringBytes::Encode(..., encoding)` handles UTF-16 (the fix's string_decoder.cc hunk). I re-added that special case. For `UCS2`, it asserts alignment and even length under `DEBUG`, then calls `Encode(isolate, reinterpret_cast<const uint16_t*>(data), length / 2)`. Other encodings go through the generic call. The other fix hunks are not reintroduced: the generic UCS2 case in `StringBytes::Encode` already exists today and is harmless. The old `StringSlice<UCS2>` specialization and the `Encode` header comments don't need restoring to bring back the decoder defect.

**Failing test:** `parallel/test-string-decoder` crashes (abort, exit -6) at test line 161 (`decoder.write(Buffer.alloc(20))` after a 1-byte write): `Assertion failed: (reinterpret_cast<uintptr_t>(data) % 2) == (0)` in `MakeString` (string_decoder.cc:47). The failure was the same on both runs.
