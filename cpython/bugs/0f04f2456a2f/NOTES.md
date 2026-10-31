`repro.py` reads the first of two same-name central-directory entries that share one local header (data from test_full_overlap_same_name), and prints the result plus any warnings.

- Clean: prints 1033 and an "Overlapped entries" UserWarning.
- Buggy: prints 1033 and no warning. The injection's `sorted(..., reverse=True)` keeps equal-offset entries in their original order, so the wrong entry gets `_end_offset == header_offset` and the warning is not emitted for the first entry.

I couldn't run `./check.sh` because the sandbox failed on a missing `.claude/launch.json`. I ran both interpreters directly instead, and the outputs differ as described.
