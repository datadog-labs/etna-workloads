# Rationale

**Bug:** Test-runner coverage with source maps counted TypeScript lines erased by type stripping (e.g. `import type {} from 'node:assert';`) as executable but uncovered. Reports showed <100% line coverage and listed them as uncovered lines.

**Change (lib/internal/test_runner/coverage.js, one hunk):** In the source-map processing loop, the fix replaced the `if (data.sourcesContent != null) { for ... this.getLines(...) }` block with a loop that also calls `this.markTypeScriptOnlyLines(source, content)`. I restored the pre-fix block, so `markTypeScriptOnlyLines` is never called and erased TS lines are never marked `ignore`. The other fix hunks (new `stripTypeScriptTypesForCoverage` helper, the method itself, regex constants) are only reachable through that call. I left them in place because they are inert without it; the old code simply did not call them.

**Failing test:** `parallel/test-runner-coverage-source-map` fails ("not ok") in two runs. The failing subtest is "should ignore erased TypeScript import type lines": the expected 100% report for `a.mts` doesn't match, because line 1 is reported uncovered.
