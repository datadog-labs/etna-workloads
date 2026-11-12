# Rationale

## Hunk changed
`src/src/planner/binder/statement/bind_create_table.cpp`, `Binder::BindCreateTableInfo`:
removed `dependencies.AddDependency(schema);`.

Traces to the fix's single hunk in `DependencyManager::AlterObject` (`!is_schema_dependency`).
In today's code that `AlterObject` condition is already in its pre-fix form
(`has_new_dependencies && !IsOwnership()` skips old non-ownership subjects, including the schema),
but the bug was masked because the ALTER re-binds the table via `BindCreateTableInfo`, which now
adds the schema to the new dependency list, so `CreateDependencies` re-adds it. Create still gets
the schema dependency via `DuckSchemaEntry::AddEntryInternal`. Removing the binder line restores the
original behaviour: ALTER TABLE passes a list without the schema, and the old schema dependency is dropped.

## Oracle result
```
FAIL     test/sql/catalog/dependencies/alter_table_keeps_schema_dependency.test
         ...:32 Query unexpectedly succeeded!
         DROP SCHEMA s;
1 of 1 oracle units fail
```
