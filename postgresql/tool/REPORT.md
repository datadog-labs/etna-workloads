# PostgreSQL bug dataset: report (clean-room run, REL_18_6)

## Funnel

| step | count |
|---|---|
| non-merge commits reachable from REL_18_6 | 62,601 |
| candidates (src/ impl + src/ tests + fix signal; 21 backport duplicates dropped) | 2,687 |
| triage (Haiku): bug / test-build-doc / feature / refactor / performance | 2,149 / 207 / 189 / 77 / 65 |
| verbatim attempted (reverse applies clean 517, with fuzz 181) | 698 |
| — gate pass / no failure / build failed / no oracle | 538 / 92 / 37 / 31 |
| adapted eligible (triaged bug, verbatim impossible or failed, has an oracle) | 1,507 |
| — attempted, newest first (Sonnet; Opus retries) | 1,167 (340 oldest not attempted: cap) |
| — gate pass / agent gave up / no failure / no patch / API error | 928 / 160 / 69 / 3 / 7 |
| anchors (adapted with a fix-added failing case): exact / build fails / no failure / other cases / reversed fails to build | 585 / 119 / 37 / 4 / 2 |
| **gated bugs** | **1,466** |
| **strict bugs** | **1,045** (460 verbatim + 585 adapted) |
| with harness-verified reproducer | 1,449 of 1,466; strict 1,035 of 1,045 |

Why gated bugs are not strict:
- verbatim: 45 have no fix-added failing case; 35 are triaged as not a bug.
- adapted: 181 have no fix-added failing case; 119 have an anchor that fails to build, because
  pre-2017 trees clash with this host's bison 3.8; 37 have an anchor with no failure; 6 other.

## Strict bugs by symptom (triage)
wrong-result 375 · spurious-error 230 · crash 105 · assertion 73 · missing-error 69 ·
security 57 · other 57 · corruption 35 · wrong-message 26 · leak 10 · hang 8

## Strict bugs by fix year
2010–2015: 14 · 2016: 57 · 2017: 85 · 2018: 73 · 2019: 100 · 2020: 73 · 2021: 96 · 2022: 89 ·
2023: 118 · 2024: 134 · 2025: 118 · 2026: 88

The fix-added rule each strict bug met: expected-output lines blamed to the fix 907, TAP
subtest name added by the fix 81, test file added by the fix 62. The rule for pg_regress
cases was approved at the probe checkpoint.

## Spend (USD, measured from `total_cost_usd`)
triage 1.54 · adapted 151.21 (cap 150) · retries 54.47 (cap 50: Opus retries plus a Sonnet
redo of API-error candidates) · reproducers 89.54 (cap 60, raised to 90 by the user) ·
**total 296.76**.
Caps are checked before each agent launches, so agents already running finished after a cap
was reached (overrun 1.21 and 4.47). Opus retries: 7 gate passes from 85 attempts. The Sonnet
redo: 31 gate passes from 38. This orchestrating session's own cost is not included.

## Quality review (15 random strict adapted bugs, read by hand)
- 12 faithful re-expressions of the fix's hunks.
- 1 the same bug expressed differently (e0693faf79, boolean partition pruning).
- 1 loosely traced (3d8874224f: the fix added an error, the injection drops a condition).
- 1 questionable label (cd69ec66c8 is closer to a feature).
- None invalid.

Locality of strict adapted injections against the fix's files: same files 532, overlap 11,
**disjoint 42** (flagged, not dropped; many are code that has since moved, such as
tab-complete.c → tab-complete.in.c and the basebackup move).

## Incidents and what was done about them
1. **`/dev/shm` full (64 MB in this container).** SIGKILLed postmasters leaked POSIX shm
   segments. From about 2026-11-03 20:00, initdb and parallel queries failed inside tests.
   - Verbatim and base runs had finished before that, and a scan found no shm errors in them.
   - All 931 adapted gate passes were re-gated from their stored injections: 928 confirmed,
     3 false positives demoted.
   - All anchors were redone.
   - The watchdog now removes orphaned segments.
   - Agent decisions made in that window (e.g. "gave up") were not redone.
2. **Memory runaway.** One injection (c3c35a733c) made a backend allocate 45 GB. It was
   killed, and a 6 GB per-process limit plus a watchdog were added.
3. **API.**
   - The credential helper was down for over an hour: 12 runs.
   - The daily spend limit was hit: 403s on 34 runs.
   - These were recorded as `api_error`, never as results; 38 were redone and 7 still
     have no result.
   - The first redo silently did nothing (stale work dirs); this was fixed.
4. **MCP overhead.** Headless agents loaded about 500k tokens of MCP tool schemas per call
   until `--strict-mcp-config` was added (cost $0.68 in triage).
5. **Anchor builds of old trees.**
   - Fixes (behaviour-neutral, recorded in `meta.json`): build without PL/Python when
     plpython.h includes eval.h (gone in Python 3.11); a core-options fallback (ICU ≥ 68
     dropped TRUE); renaming pg_rewind's `copy_file_range` (clashes with glibc); a flex
     version wrapper.
   - Not fixed: bison 3.8 vs grammars from 2016 and earlier → 119 "build fails".
6. **Reproducers.** 8 harness-verified reproducers loaded test modules from my build trees.
   They were rejected as non-portable; the bugs stay, without reproducers.
7. **Process management.** An early `pkill -f` matched my own shell. Processes are now
   selected by PID or executable path only.

## Known gaps
- PL/Perl is not built: libperl.so is missing, and installing it needs approval.
- LDAP, Kerberos, OAuth, SSPI and load-balance DNS tests, and `src/test/mb`, are not run.
- Determinism was checked only on this host (2 clean runs).
- Marauders itself was not run (binary not installed). The patches use the same `git apply`
  the `bin/` scripts use.
- End-to-end check from a fresh clone: 3 random strict bugs. All three were reported
  `BUG PRESENT` after apply and `CLEAN` after revert, by both reproducer and tests.

Tooling: `tools/` (clean-room, written for this run).
