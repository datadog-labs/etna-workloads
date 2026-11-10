# Re-introduced bug: watch mode does not reload --env-file changes (nodejs/node#54001)

**Bug.** With `node --watch --env-file=.env app.js`, edits to the env file did not cause a restart. Also, the watch-mode parent process loaded the env file into its own environment, so the restarted child inherited the stale variables (dotenv never overrides existing vars) and saw old values.

**Hunks.**
1. `src/node.cc` (StartExecution): restored the pre-fix condition `if (env->options()->has_env_file_string)`, dropping `&& !env->options()->watch_mode` and its comment. This matches the fix's `src/node.cc` hunk. The parent in watch mode loads the env file again, so the child inherits stale values.
2. `lib/internal/main/watch_mode.js` (start): removed the `if (kEnvFiles.length > 0) { ... watcher.filterFile(resolve(file)) }` block. This matches the fix's `watcher.filterFile(resolve(kEnvFile))` hunk (today it is a loop over `kEnvFiles`). The env files are no longer watched. I left the optional `--env-file-if-exists` block alone, since the original fix did not cover it.

**Failing tests** (`sequential/test-watch-mode`, failed in 3 runs):
- 'should reload env variables when --env-file changes': `Error: Timed out waiting for restart`
- 'should load new env variables when --env-file changes': `Error: Timed out waiting for restart`
