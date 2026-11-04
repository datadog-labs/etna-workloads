# Rationale

Bug (#19219): the TopK aggregation optimizer only validated the group-key type and
never the MIN/MAX value type, and the TopK heap had no string support, so
GROUP BY ... ORDER BY min/max(string) ... LIMIT reached execution with unsupported types.

## Changes
1. `datafusion/physical-optimizer/src/topk_aggregation.rs`: reverses the hunk replacing the
   inline key-type check with `topk_types_supported(&kt, vt)`. Restored the key-only check
   (primitive/Utf8/Utf8View/LargeUtf8), no value-type check.
2. `datafusion/physical-plan/src/aggregates/topk/heap.rs`: reverses the hunks adding string heap
   support. `new_heap` no longer dispatches string value types to `StringHeap`,
   `is_supported_heap_type` is primitive-only, and the error text is `Can't group type`.
   (`StringHeap` is left in place but unused.)

The `with_new_limit` / `with_new_limit_options` cloning hunk was not reverted: it is a refactor, not part of the fault.

## Oracle
`aggregates_topk.slt` fails: a string-valued query is planned with TopK and then panics in
`grouped_topk_stream.rs` ("TopK type validation should have been performed by optimizer ... key=Utf8View, value=Utf8View").
