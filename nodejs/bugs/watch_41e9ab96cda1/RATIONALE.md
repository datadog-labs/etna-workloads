# Re-introduced bug: watch mode NODE_OPTIONS quoting (fix 41e9ab96)

**Bug.** When `--watch` strips watch flags from NODE_OPTIONS, it tokenizes the string and rejoins the kept tokens for the child. Values were re-quoted only if they contained a space, and nothing inside the quotes was escaped. A value with a `"` made the child fail with "unterminated string". A backslash inside a quoted value was silently dropped.

**Hunk 1** (`lib/internal/main/watch_mode.js`, the re-quoting block in the NODE_OPTIONS loop). This corresponds to the fix's main hunk. It restores the old code: quote only when the part includes a space, with no escaping of `\` or `"`: `ArrayPrototypePush(keep, StringPrototypeIncludes(part, ' ') ? \`"${part}"\` : part)`. The old comment is restored too.

**Hunk 2** (same file, destructuring import). The fix added `StringPrototypeReplaceAll` to the imports. In the current release, `normalizeOptionName` also uses it, so the import has to stay. I left it in place and did not revert that part of the fix.

**Failing tests** (`sequential/test-watch-mode`, stable across 2 runs):
- `should preserve NODE_OPTIONS values containing a double quote in child process`
- `should preserve NODE_OPTIONS values containing a backslash in child process`

I did not capture the exact assertion text for these two failures. Both fail because the child sees the wrong `process.title` or errors on startup.
