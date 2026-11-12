# Rationale

Hunk changed: `src/src/parallel/scan_read_ahead.cpp`, class `FileOpenTask`. I removed the `void Cancel() override { cancel_fn(); }` override. This traces to the fix's hunk that adds `Cancel()` to `FileOpenTask`.

Without the override, a file open that is retired without running never calls its cancel callback. The reader stays in OPENING and the waiter is not told to stop. This is the original bug.

I kept the two-argument `ScheduleFileOpen` signature, the `cancel_fn` member, the caller's cancel lambda and the atomic `error_opening_file`. The fix's test calls the two-argument form, so reverting the signature would break the build.

The 1-argument form was tried first and failed to compile against the test file.

## Oracle result
```
PASS     ...::Parquet read-ahead supports a schema supplied without binding a file
PASS     ...::Read-ahead progress only counts the assignments a thread is decoding
FAIL     ...::Read-ahead settles a file open that never runs
         test_read_ahead_progress.cpp:98 :: settled 0
PASS     ...::Automatic read-ahead grows its backlog within the memory budget
1 of 4 oracle units fail
```
Only the new symptom test fails. The other three listed units still pass.
