# Bug
`--prof-process` options were parsed as Node.js options, so flags meant for the tick processor (e.g. `--preprocess`) were rejected with "bad option".

# Change
- src/node_options.cc: removed `AddAlias("--prof-process", {"--prof-process", "--"})` (and its comment). This corresponds to the fix's src/node_options.cc hunk; without the alias, options after `--prof-process` are no longer terminated with `--` and get parsed by Node.
- The fix's lib/internal/bootstrap/node.js hunk has no counterpart: that alias-expansion code no longer exists in the release (aliases are handled in C++), so nothing to revert.

# Failing test
parallel/test-tick-processor-arguments: `node: bad option: --preprocess`, child exits with status 9.
