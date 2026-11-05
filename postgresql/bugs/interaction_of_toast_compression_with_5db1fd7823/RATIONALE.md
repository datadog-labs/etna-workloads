# Rationale

Changed: src/src/backend/access/common/toast_internals.c, `toast_compress_datum`.
I removed the "if method invalid, use default_toast_compression" fallback.

The fix added that fallback at the callers. Traced hunks:
- indextuple.c `index_form_tuple`: fall back to the default if `att->attcompression` is invalid.
- brin_tuple.c `brin_form_tuple`: same fallback for the BRIN summary.
- index.c `ConstructTupleDescriptor`: sets `attcompression` to `InvalidCompressionMethod` for expression columns.

In current code the fallback was consolidated into `toast_compress_datum`, so that is where I reverted it.
The index.c hunk is still present, and expression index columns still carry an invalid method.
Without the fallback, compressing a large expression-index value hits `elog(ERROR, "invalid compression method")`.
That is the original bug.

Failing oracle case: src/test/regress||compression
