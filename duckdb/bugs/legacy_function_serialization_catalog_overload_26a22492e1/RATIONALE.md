# Rationale

Hunk changed: `src/catalog/catalog_entry/table_function_catalog_entry.cpp`, `TableFunctionCatalogEntry::AlterEntry`.
Traces to the fix's first hunk, which added `new_info.internal = internal;`. I removed that line.
When overloads are added to an existing table function, the replacement entry is created from a fresh
`CreateTableFunctionInfo`, so `internal` is no longer carried over and the entry loses its internal flag.
The aliased-overloads test (ALTER_ON_CONFLICT path) therefore trips an assertion; the registration test passed.

Only this hunk was reverted. The other hunks (legacy rebind serialization, compression-origin property 203)
touch headers or would need a large rebuild, so they were left as they are.

Oracle results: 1 of 18 units fail.

```
FAIL     cpp:test/api/test_extension_schema_api.cpp::Aliased table function overloads retain catalog identity
         ... Assertion triggered in dependency_manager.cpp on line 726: IsSystemEntry(old_obj)
```
The altered entry lost `internal`, so the dependency manager's system-entry assertion fires when the entry is replaced.
The other 17 units still pass; the first registration test did not fail with this hunk alone.
