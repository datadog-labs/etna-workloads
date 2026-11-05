# Rationale

## src/backend/executor/execTuples.c, HeapTupleHeaderGetDatum()
Traces to the fix.patch execTuples.c hunk that adds HeapTupleHeaderGetDatum (replacing the
old PointerGetDatum-equivalent macro) and its use of toast_flatten_tuple_to_datum.
The function now just returns PointerGetDatum(tuple), as the pre-fix macro did, so
composite Datums built via heap_form_tuple + HeapTupleGetDatum (e.g. ROW(x,42)) keep
external TOAST pointers. These end up inside arrays/ranges stored on disk and dangle
once the source row is deleted.

## Failing oracle cases
- src/test/regress||arrays
