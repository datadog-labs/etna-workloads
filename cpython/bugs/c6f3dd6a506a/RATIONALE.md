# Rationale (gh-98896)

Changes in `tree/Lib/multiprocessing/resource_tracker.py`:

1. `_send`: the fix replaced the `f"{cmd}:{name}:{rtype}\n"` colon-separated message with a
   JSON+base64 message. v3.15.2 keeps the simple format for names without `\n`; I made it
   unconditional (`if True:`), so every name, including ones with colons or newlines, is
   sent in the old colon-separated format.
2. `_decode_message` (simple-format branch): restored the pre-fix
   `cmd, name, rtype = line.strip().decode('ascii').split(':')` in place of the
   `split(':', 1)` / `rsplit(':', 1)` pair that now tolerates colons in names.

Result: names with colons or newlines make the tracker fail with
"not enough values / too many values to unpack" and a traceback on stderr.
The failing oracle case is `TestSharedMemoryNames.test_that_shared_memory_name_with_colons_has_no_resource_tracker_errors`.
