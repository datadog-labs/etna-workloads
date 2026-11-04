# Rationale

Fix hunk reversed: `build_schema_helper` in `datafusion/datasource-csv/src/file_format.rs`.

1. Removed `data_type_possibilities.remove(&DataType::Null)`. A column whose chunks
   infer as [Null, Int64] again yields two possible types and falls to Utf8.
2. The `0 =>` arm (no types) now returns Utf8 again instead of Null (the fix added
   `0 => Null`; before it, the empty set hit the `_ => Utf8` arm). The now-unused
   `disable_inference` parameter is renamed `_disable_inference`, and the `mut` on
   the binding is dropped, to keep the build warning-free.

Oracle: ddl.slt `empty` table (header-only CSV) reports c1..c3 as Utf8 instead of Null.
Also reintroduces the null-chunk/ mixed empty-file schema merge problem
(`sum(c3)` over some_empty_with_header would see Utf8 vs Int64 conflicts).
