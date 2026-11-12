# Rationale

Both hunks are in `src/function/table/system/logging_utils.cpp`. They undo the logging part of the upstream fix.

1. `EnableLogging` (hunk 1 of the fix): removed the `previous_config` snapshot and the try/catch. If `SetConfig`, `SetEnableStructuredLoggers` or `UpdateLogStorageConfig` throws part-way, the previous logging config is no longer restored. `enable_logging` is non-atomic again.
2. `BindEnableLogging` (hunk 2 of the fix): removed the `LookupLogType` check that threw `Unknown log type: '%s'`. Unknown log types are no longer rejected at bind time, before any settings change.

Not changed: the `QueryResult::CompleteInternal` hunk. Today's code was refactored (`AbandonAfterThrowInternal`) and the original form can't be reproduced faithfully. The oracle tests only exercise the logging hunks.

## Oracle results
See the etna-check output below.

2 of 2 oracle units fail:

    FAIL test/sql/logging/logging_call_functions.test:187
         Mismatch on row 4, column value(index 2): DEBUG <> INFO
         (actual logging_level DEBUG, logging_storage file: the failed enable_logging left its settings applied)
    FAIL test/sql/logging/test_enable_logging_unknown_type_file_storage.test:8
         Expected "Unknown log type: 'nope'", got
         "Invalid Configuration Error: Failed to initialize file log storage table, path wasn't set"
    2 of 2 oracle units fail
