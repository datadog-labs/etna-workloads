# Rationale

Fix: `call_count` was incremented with `self.call_count += 1` (non-atomic); the fix derives it from `len(self.call_args_list)`.

In v3.15.2 this is protected differently, so two places were reverted in `Lib/unittest/mock.py`:

1. `NonCallableMock._increment_mock_call`: removed the `with NonCallableMock._lock:` block and `self.call_count = len(self.call_args_list)`; restored `self.call_count += 1` before building/appending `_call` (the pre-fix code). Reverses the fix hunk that moved the count to `len(call_args_list)`.
2. `ThreadingMock._increment_mock_call` override (wraps the base in `_mock_calls_events_lock`) was removed. It serialised the increment and hid the bug for ThreadingMock, which is what the oracle uses. Same defect (unsynchronised call_count increment), covered by a second path.

Oracle: `test_call_count_thread_safe` fails (`AssertionError: 902 != 1000`). The other 22 cases pass.
