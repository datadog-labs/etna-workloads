# Re-introduced bug: watch mode vs. multiple env files (nodejs/node#60605)

## Bug
`--env-file` / `--env-file-if-exists` can be repeated, so their option values are arrays. Before the fix,
`lib/internal/main/watch_mode.js` still treated the value as a single path:
`const kEnvFile = getOptionValue('--env-file') || getOptionValue('--env-file-if-exists')`, then
`watcher.filterFile(resolve(kEnvFile))`. An array (even an empty one, which is truthy) is passed to `path.resolve()`,
which throws `ERR_INVALID_ARG_TYPE`. Watch mode therefore breaks, and with several env files it could never
watch all of them.

## Change (only `lib/internal/main/watch_mode.js`)
- Hunk 1 (`kEnvFiles = [...--env-file, ...--env-file-if-exists]` -> `kEnvFile = a || b`): restored the single-value
  constant. It matches the fix's first hunk, written for today's code. Today's code has separate `kEnvFiles` and
  `kOptionalEnvFiles` constants, with `allowMissing` for the optional ones.
- Hunk 2 (`if (kEnvFiles.length > 0) forEach(filterFile(resolve(file)))` -> `if (kEnvFile) filterFile(resolve(kEnvFile))`):
  restored the single-path filtering. The optional-file `allowMissing` block was dropped, since it is part of the
  per-file loop the fix introduced.
- The `src/node_options.h` hunk (`std::string` -> `std::vector<std::string>`) is deliberately NOT reverted. The tests
  still pass with string options, because `Dotenv` reads the flags from argv, not from the options. With string options
  no oracle test fails. Keeping the vector options in C++ with the old JS gives the failing state described above.
  This is a deviation from a literal reversal.

## Failing tests
`sequential/test-watch-mode` fails on every run (`not ok 2 sequential/test-watch-mode`), e.g.
`Test failure: 'should pass IPC messages from a spawning parent to the child and back'`. The watch parent throws
`ERR_INVALID_ARG_TYPE` from `resolve()` on an array argument. `parallel/test-dotenv-edge-cases` still passes, since its
only new test in the fix covers behaviour that does not change here. The failure was stable over two runs.

I did not capture the exact `ERR_INVALID_ARG_TYPE` text from the test output. It is inferred from the code path.

Build note: after the header round-trip, stale `.o` files that referenced `EnvironmentOptions` had to be deleted
before the snapshot builder stopped segfaulting. The final tree builds cleanly.
