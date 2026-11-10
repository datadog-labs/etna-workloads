# Brotli flush range regression

**Bug:** `options.flush` / `options.finishFlush` for Brotli streams were validated against the zlib range (Z_NO_FLUSH..Z_BLOCK, i.e. 0..5) instead of the Brotli operation range (BROTLI_OPERATION_PROCESS..EMIT_METADATA, 0..3). Invalid values such as `Z_FINISH` (4) were accepted for Brotli instead of throwing ERR_OUT_OF_RANGE.

**Change (lib/zlib.js, one hunk):** in `ZlibBase`, removed the branch that selects `FLUSH_BOUND_IDX_BROTLI` for `BROTLI_ENCODE`/`BROTLI_DECODE`, so Brotli modes fall through to `FLUSH_BOUND_IDX_NORMAL`. This corresponds to the fix's `flushBoundIdx` selection hunk (the FLUSH_BOUND table and the checkRangesOrGetDefault calls now carry a zstd index too, so I reverted the selection rather than the table).

**Failing test:** `parallel/test-zlib-brotli` — `brotliCompressSync('', {flush: Z_FINISH})` no longer throws the expected ERR_OUT_OF_RANGE ('...must be >= 0 and <= 3. Received 4').
