# Bug
Globstar (`**`) in fs.glob patterns skipped every dot file/dir, even when the pattern
after `**` explicitly matched it (e.g. `**/.b`, `a/**/.b` returned nothing).

# Change (lib/internal/fs/glob.js, two hunks: sync and async #iterateSubpatterns)
In the `current === GLOBSTAR` branch, I replaced the isDot/nextMatches/nextNonGlobIndex/matchesDot
logic and the `(isDot && !matchesDot) || exclude` check with the original
`entry.name[0] === '.' || exclude(...)` check, and moved `const nextMatches = pattern.test(...)`
back to after the "Any pattern after ** ..." comment. This corresponds to the fix's two
implementation hunks (the fix's third refactor of results-adding is not needed; code has since changed).
Unconditional dot skipping restores the old behaviour.

# Failing tests
parallel/test-fs-glob: not ok; assertion diffs show `actual: []` vs expected arrays
for the `**/.b`, `./**/.b`, `a/**/.b` patterns. Stable across two runs.
