Starts the same patcher twice, then stops it twice. Clean: second start raises
RuntimeError("Patch is already started") and a repeated stop is a no-op. Buggy: the
second start succeeds (re-patching with the patched value as original) so stop
leaves A.x patched, and the second stop raises an error.
