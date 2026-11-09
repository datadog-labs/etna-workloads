# TypeScript compiler (tsc v6.0.3) etna-style bug dataset: run report (2026-11-09)

Clean-room run: all tooling in `tools/` was written for this run (no etna-workloads or sqlite/tool content).

## Funnel

| stage | count |
|---|---|
| non-merge commits reachable from v6.0.3 | 28,951 |
| candidates (scope impl + tests + fix signal, backport dups removed) | 3,910 |
| triaged `bug` (haiku, one pass) | 3,432 |
| reverse-apply on v6.0.3: clean / fuzzy / conflict | 303 / 147 / 3,460 |
| verbatim gate runs (applying, with oracle units) | 445 |
| verbatim gate pass / no failure / build failed | 370 / 34 / 41 |
| adapted pool (triaged bug, fix >= 2022-11 hereby era, verbatim not passing) | 304 |
| adapted (sonnet) gate pass / no failure / agent made no change | 266 / 26 / 12 |
| opus retries (18, conf >= 0.8): gate pass | 1 |
| anchors of 267 adapted passes: exact / exact-normalized / not exact / reversed build fails / other | 239 / 7 / 9 / 9 / 3 |
| exported bugs (all gate passes) | 637 |
| **strict** | **509** (308 verbatim, 201 adapted) |
| reproducers verified by harness | 637 / 637 (509 / 509 strict) |

Not-strict reasons (a bug can have several): no failing case added by the fix 105, adapted anchor
not exact 26 (not_exact 9, reversed build fails at fix 9, exact only after title normalisation 7,
no cases at fix 1), pre-hereby revision 2, triage non-bug 9, untraced hunk in hand review 1.

Strict by tier/symptom/year: see `workload/typescript/README.md` (generated from meta.json).
Top symptoms: wrong language-service result 160, wrong type 91, crash 78, false error 61.
Years: 2022 28, 2023 247, 2024 165, 2025 56, 2026 8, older 5.

## Spend (USD, from the per-call ledger)

triage 1.09, adapted 24.45, adapted retries (opus) 7.24, reproducers 39.16, total 71.95
(+ about $0.01 of unledgered sandbox/CLI probes). Caps were 5 / 140 / 35 / 100 (+20 reserve); none hit.
Per agent: adapted median about $0.07, reproducer about $0.05.

## Base

10,352 test units -> 60,813 cases (mocha `it`), two runs: all pass in both, 0 flaky, 0 incomplete.
Built as the project's own CI tests it (`hereby local tests`, type-checked bundle, `light=false`).

## Hand review (step 8)

Random 15 of 202 strict adapted (seed 20261109): 14 faithful, minimal, every hunk traceable
to a fix hunk (several re-express code that moved: checker.ts -> expressionToTypeNode.ts /
utilities.ts createNameResolver, refactors -> moveToFile.ts). 1 suspicious: 5b10466b6355 adds a
"supporting" hunk from an earlier commit (3258d75169) because reversing only the fix's hunks
changed nothing; demoted to loose (`untraced hunk`). Estimated rate about 1/15.
A heuristic identifier-overlap check over all 267 adapted passes flagged 5 more hunks; on reading,
these were import-list edits and relocated code, not violations (the heuristic does not catch the
5b10466b pattern, so the remaining adapted set has not been fully hand-checked).
Locality (adapted passes): same file 258, overlap 1, disjoint 8 (all relocated code; flagged in
meta.json, not dropped). All 370 verbatim injections have changed lines identical to the reversed
fix (including the 69 applied with fuzz).
Reproducers: spot-checked 6 by hand; all show genuine compiler/LS behaviour differences.

## Problems found and what was done

- Python text-mode edits would have rewritten CRLF files: all edits byte-preserving.
- Tests ran against a stale bundle after a failed build (harness bug): gate refuses to test on failure.
- Rebuild targets missed typescript.js (reproducer agent noticed): added services/tsserver targets
  and a stale-build guard; the affected reproducer was redone with public API only.
- Unittest scenarios added inside existing files were not counted as fix-added: added
  baseline-name matching.
- Anchor tooling: node_modules cache race (2 parallel installs of the same lockfile left a broken
  cache marked done) -> lock + cache validation; relative-path invocation bug in a manual redo; case
  titles renamed between revisions (`(@target: es5)` config labels added in TS 6, `::` suite
  suffixes) -> separate `exact_normalized` label (not counted strict); same-day pre-hereby commit
  -> era check by Herebyfile presence. All non-exact anchors were re-run after each fix.
- Exported reproducers: agents left `out/` and `.claude/` at repro roots; stripped and all 149
  affected re-verified from the exported files (3 had expected output regenerated); reproducers
  whose injected output is nondeterministic (stack overflow depth) are checked by "differs from
  clean".
- End to end from a fresh GitHub checkout (bin/etna.py): 5 random bugs (2 verbatim, 2 adapted,
  1 unittest): set -> repro BUG + tests BUG; unset -> repro CLEAN + tests CLEAN, tree clean.

## Known gaps

- Pre-2022-11 fixes (gulp build, namespaces) were not adapted/anchored (would need old Node/gulp).
- Oracle limited to the fix's own test files; triage is one small-model pass.
- Strict adapted set hand-reviewed on a 15-bug sample only.
- Not yet published (step 10 needs the workloads repository and push/PR permission).
