# Re-introduced bug: repeated normalizeSpawnArguments in execFileSync

**Bug.** `execFileSync` normalized its arguments with `normalizeSpawnArguments`, then passed the normalized
`options.file` / `options.args` / `options` to `spawnSync`, which normalized them a second time. With
`{ shell: true }` the first pass already builds the `/bin/sh -c "file args"` command line, and the second pass
wraps that again, so the command is mangled. `execFileSync('echo', ['foo','bar'], {shell:true})` returned
`"\n"` instead of `"foo bar\n"`, which disagreed with `execFile`.

**Hunk (lib/child_process.js, `execFileSync`)**
This corresponds to the fix's `execFileSync` hunk. The fix replaced the `normalizeSpawnArguments` call with
`normalizeExecFileArgs`, passed `(file, args, options)` straight to `spawnSync`, and built `errArgs` with
`ArrayPrototypePushApply`. I restored the old body:
`options = normalizeSpawnArguments(file, args, options)`, then
`spawnSync(options.file, ArrayPrototypeSlice(options.args, 1), options)`, then
`checkExecSyncError(ret, options.args, undefined)`.
That brings back the double normalization.

I left `normalizeExecFileArgs` in place because `execFile` still uses it. Reversing that part of the fix hunk
would not be faithful to today's code. `ArrayPrototypePushApply` is still imported and may now be unused in
this file.

**Failing test.** `parallel/test-child-process-execfile` fails on the new "execFile() stdout is the same as
execFileSync()" block with `AssertionError: '\n' !== 'foo bar\n'`.
