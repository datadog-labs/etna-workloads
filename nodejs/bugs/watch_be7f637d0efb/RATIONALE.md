# Re-introduced bug: watch mode child inherits watch flags from NODE_OPTIONS

**Bug.** When `NODE_OPTIONS` contains `--watch` (or `--watch-path`, `--watch-preserve-output`, `--watch-kill-signal`), the watch-mode parent spawns its child with the unchanged environment. The child therefore starts in watch mode itself, which causes a recursive/infinite loop of watchers (issue #61740).

**Change (lib/internal/main/watch_mode.js only).**
- Removed the block that parses `NODE_OPTIONS` (`parseNodeOptionsEnvVar`), filters the watch flags and re-quotes the rest. This corresponds to the fix hunk that adds the "Strip watch-related flags" block.
- Removed `NODE_OPTIONS: cleanNodeOptions` from the child `env`. This corresponds to the fix hunk in `start()`. The child now gets the raw `NODE_OPTIONS`, as before the fix.
- Removed the now-unused imports (`StringPrototypeIncludes`, `parseNodeOptionsEnvVar`). This corresponds to the fix's import hunks.
- The C++ binding and `lib/internal/options.js` export are left in place. They are harmless on their own, and test-options-binding still passes.

**Failing test.** `sequential/test-watch-mode` fails ("not ok 2") in two consecutive runs. The new tests that check NODE_OPTIONS stripping can no longer pass, because the child still sees `--watch` and the other watch flags. I did not capture the individual failure messages.
