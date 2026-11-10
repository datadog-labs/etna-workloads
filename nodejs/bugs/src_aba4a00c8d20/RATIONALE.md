# Re-introduced bug: argv not passed to worker threads (nodejs/node#52825)

**Bug.** When `new Worker()` is called without an explicit `execArgv` array, the parent's
CLI flags (e.g. `--expose-internals`) are not propagated to the worker. The worker's
per-isolate options are built only from NODE_OPTIONS / env, so the worker behaves as if
started without those flags (e.g. `require('internal/options')` throws).

**Change (src/node_worker.cc, `Worker::New`).** One hunk: removed the `else` branch after
`if (args[2]->IsArray()) {...}` that appended `env->exec_argv()` to the `exec_argv` vector
before `options_parser::Parse`. This corresponds to the fix's added
`else { exec_argv_out = env->exec_argv(); exec_argv.insert(...) }` branch. Without it, when
no execArgv array is given, only the empty program-name entry is parsed, so parent flags
are lost, as before the fix. (The fix's other hunks — moving the block inside the options
`if` and reformatting — are already structurally present in the release and are
behaviour-neutral.)

**Failing test.** `parallel/test-worker-cli-options` -> `not ok 1` (stable across 2 runs):
the worker without execArgv fails to `require('internal/options')` because
`--expose-internals` was not inherited.
