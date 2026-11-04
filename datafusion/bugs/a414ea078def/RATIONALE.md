# Rationale

Fix: issue 19781, `FilterExecStream::poll_next` pushed into a `LimitedBatchCoalescer` after it had been finished.

Changes (all in `tree/datafusion/physical-plan/src/`):

- `filter.rs`, `poll_next`: restored the pre-fix loop. On `LimitReached` or input end it calls `flush_remaining_batches()` and returns one batch, instead of draining the coalescer across polls and checking `is_finished()`. After a limit-triggered flush the input is polled again and pushed into the finished coalescer. This reverses the fix's rewrite of the loop. I also dropped the later "release input pipeline" `EmptyRecordBatchStream` replacement, which would have masked the bug by making the input return `None`. It covers the same case, so it is the same defect.
- `filter.rs`: restored `FilterExecStream::flush_remaining_batches` and the `LimitReached` import (the fix removed both). Removed the now-unused `EmptyRecordBatchStream` and `PushBatchStatus` imports.
- `coalesce/mod.rs`: `is_finished()` is now unused, so I added `#[allow(dead_code)]` to avoid a warning. This does not change behaviour.

Oracle: `limit_single_row_batches.slt` fails with `Internal error: Assertion failed: !self.finished: LimitedBatchCoalescer: cannot push batch after finish`. This is the error from the issue. `limit.slt` still passes.
