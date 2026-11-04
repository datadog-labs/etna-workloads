# Rationale

Only file changed: `tree/datafusion/physical-plan/src/union.rs`, `union_schema`.
In 55.2.0 the function still has the fix's structure (plus later additions: Result return, name from the left side), so I put back the pre-fix logic in the same function.

## Hunk 1: per-field metadata
The fix merges metadata from every *other* input into each candidate field. I reverted this to the old behaviour: each candidate field gets only the metadata of the right-hand input (`inputs.get(1)`). If the nullable field picked by `find_or_first` is not input 0 (e.g. `SELECT nonnull_name ... UNION ALL SELECT NULL`), the left side's metadata is lost.

## Hunk 2: schema-level metadata
The fix merges the schema metadata of all inputs. I reverted this to taking only `first_schema.metadata()` (inputs[0]). If the input that carries the schema metadata is not first, the metadata is lost.

## Oracle
`metadata.slt` fails on the two regression queries, at lines 158 and 172. The error is "Internal error: Physical input schema should be the same as the one converted from logical input schema", which is the logical vs physical schema mismatch the fix addressed.
