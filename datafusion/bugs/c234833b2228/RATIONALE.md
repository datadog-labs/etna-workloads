# Rationale

Fix: avoid recursive External wrapping of errors (#14371). In 55.2.0 the fix's code is all still present, so reversing any single hunk is not enough. The `From<GenericError>` hunk alone changes no oracle result, because the other paths already use `Shared`. I reverted the three code paths together.

## Hunks reverted
- `datafusion/common/src/error.rs`, `impl From<GenericError>`: reverses the "don't wrap a DataFusionError" hunk. It now always returns `DataFusionError::External(err)`, as before the fix.
- `datafusion/physical-plan/src/repartition/mod.rs`, `wait_for_task`: reverses the `DataFusionError::from(&e)` hunk. It sends `External(Box::new(Arc::clone(&e)))` to each output partition again. This is the same defect in a second path, so I reverted it as well.
- `datafusion/physical-plan/src/joins/utils.rs`, `OnceFut::get` and `get_shared`: reverse the `DataFusionError::from` and `Shared` hunks. They wrap in `External(Box::new(..))` again. This is the same defect in a third path, so I reverted it too.

I kept the `Shared` variant and the `From<&Arc<..>>` impl. `try_once` still uses `Shared`; it is not part of the fix's hunks.

## Oracle
- `aggregate.slt` fails. The expected error `DataFusion error: This feature is not implemented: Tdigest max_size...` (the `Error during planning` wording is the current 55.2.0 text) now comes back as `DataFusion error: External error: Error during planning: Tdigest ...`. The error is wrapped in `External` again, which is what the fix prevents.
- `errors.slt` still passes. Its divide-by-zero query does not trigger the wrapping in 55.2.0.
