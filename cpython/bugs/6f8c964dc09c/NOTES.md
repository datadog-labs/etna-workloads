Writes two identical samples with an empty-stack thread (fresh thread id) via `_remote_debugging.BinaryWriter.write_sample`, then finalizes.
Clean: prints `ok`. Buggy: `RuntimeError Invalid stack encoding type` (STACK_REPEAT on a new thread is not buffered for RLE).
