# Bug
Workers ignored env-derived options (NODE_OPTIONS and NODE_PRESERVE_SYMLINKS-style env options) from a user-provided `env`; only execArgv was parsed. Invalid NODE_OPTIONS in an explicit env was never rejected.

# Change (src/node_worker.cc, Worker::New)
- Condition `args[1]->IsObject() || args[2]->IsArray()` -> `args[2]->IsArray()`: corresponds to the fix's `if (args[1]->IsObject() || args[2]->IsArray())` block; the old code only built per-isolate options for explicit execArgv.
- Removed the HandleEnvOptions + NODE_OPTIONS parsing block (incl. `invalidNodeOptions` reporting): corresponds to the fix's added env parsing hunk; before the fix env was never parsed for options.
(The env argument plumbing in JS/C++ is kept as-is; reverting it was not needed to restore the behaviour.)

# Failing tests
parallel/test-require-symlink (Worker with env NODE_PRESERVE_SYMLINKS does not preserve symlinks -> worker error) and parallel/test-cli-node-options (worker variants do not pick up NODE_OPTIONS). Both "not ok", stable across runs.
