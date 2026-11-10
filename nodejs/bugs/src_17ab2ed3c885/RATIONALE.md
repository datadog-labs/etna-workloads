# Re-introduced bug: NODE_OPTIONS splitting does not ignore repeated white space

**Bug.** The original `SplitString` (src/util.cc) used `std::getline` and kept empty items, so
consecutive/leading delimiters in NODE_OPTIONS produced empty-string arguments. The fix skipped empty items.

**Adaptation.** `SplitString` no longer exists in v26.13.0. NODE_OPTIONS is tokenized in
`ParseNodeOptionsEnvVar` (src/node_options.cc), where the `will_start_new_arg` flag plays the role of
`if (item.empty()) continue;`.

**Hunk (src/node_options.cc).** In the `c == ' ' && !is_in_string` branch I added
`if (will_start_new_arg) env_argv.emplace_back();`. This corresponds to the fix's single hunk (the
`item.empty()` skip), removed: a space that follows another space (or leading space) now yields an empty argument.

**Failing test.** `parallel/test-cli-node-options` fails (stable across runs):
`for "   --require .../printA.js    --require .../printA.js", failed to find /A\nB\n/ in: <B>`
(the empty args make the option parse fail / the requires are not applied).
