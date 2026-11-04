# Rationale

Fix hunk reversed: the `// parse sep` hunk in `concat_ws.rs` (array separators handled for Utf8, LargeUtf8 and Utf8View). In 55.2.0 that logic was moved into the shared `ColumnarValueRef::from_columnar_value`, so the hunk can't be reversed directly. Instead, `ConcatWsFunc::invoke_with_args` (datafusion/functions/src/string/concat_ws.rs) now calls `as_string_array(array)?` on an array separator before building `sep`. This restores the pre-fix behaviour where an array separator was only accepted as Utf8, and any other type fails with a downcast internal error. Scalar separators are unchanged, as before the fix.

Oracle: expr.slt fails on both new queries, `concat_ws(arrow_cast(sep,'Utf8View'), ...)` and `concat_ws(arrow_cast(sep,'LargeUtf8'), ...)`. Both return "Internal error: could not cast array of type Utf8View to GenericByteArray<...>" (the same error text appears for the LargeUtf8 query).
