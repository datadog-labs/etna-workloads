# z3: historical Z3 bugs re-injected into z3-5.3.3

254 bugs from the fix history of the [Z3 SMT solver](https://github.com/Z3Prover/z3),
each re-injected as a patch into release **z3-5.3.3** (commit `430d19e6`), and verified
by tests. **112 are strict** (the headline set; see definitions). Built with the
clean-room pipeline in `tool/` (no code from other workloads).

| | count |
|---|---|
| gated bugs | 254 (169 from fixes with in-repo tests, 85 from the z3test pool) |
| strict | 112 (86 verbatim, 26 adapted) |
| with a verified standalone `repro.smt2` | 223 of 254; 93 of 112 strict |

Strict bugs by symptom (triage): wrong model 40, soundness (wrong sat/unsat) 34, crash 14,
nontermination 7, assertion violation 6, incompleteness 4, resource 3, other 4.
By fix year: 2026: 108, 2025: 3, 2021: 1 (older fixes rarely survive into today's code
in a testable form). Top subsystems: seq 17, fpa 7, sat 7, rewriter 5, smt/arith 5, api 5, nlsat 5.

## Layout

```
bugs/<name>/            one directory per bug
  injection.patch       the bug (implementation files only; apply with git apply at the Z3 root)
  meta.json             fix commit/date/subject, report links, pool, tier, labels, locality, anchor, strict
  oracle.json           oracle cases, the failing ones, and both injected runs per case
  RATIONALE.md          adapted tier: the agent's hunk-by-hunk trace to the fix; verbatim: provenance
  repro.smt2            standalone reproducer (z3 repro.smt2), when one was verified
  repro.expected.clean  normalized output + exit status of the clean release build
  repro.expected.buggy  same for the injected build
  z3test/...            vendored z3test regression oracles (z3test pool only)
patches/<name>.patch    the same injections for Marauders (marauder.toml)
bugs.json, bugs.csv     index of all bugs
bin/                    setup / build / apply / revert / check scripts
tool/                   the mining and verification pipeline
```

## Usage

```
bin/setup.sh                 # clone z3-5.3.3 into ./z3-src, configure (Debug, assertions on), build
bin/apply.sh  <bug>          # apply the injection
bin/build.sh                 # incremental rebuild of z3 and test-z3
bin/check.sh  <bug> [repro|tests|both]   # BUG / CLEAN per method; exit 1 if any reports BUG
bin/revert.sh <bug>          # reverse the injection; verifies the tree is byte-identical to the release
```
Builds: CMake + Ninja, `CMAKE_BUILD_TYPE=Debug` (Z3DEBUG assertions and tracing) with
`-O1 -g0`. Full build ~8 min on 14 cores; most injections rebuild in under a minute.
Marauders: `bin/setup.sh` links `patches/` and `marauder.toml` into the checkout root.

## Definitions (as applied)

- **Candidate**: non-merge commit reachable from z3-5.3.3 that changes implementation files
  under `src/` (not `src/test/`, not language bindings other than the core C API) *and*
  `src/test/`, with a fix signal (issue reference or fix wording); patch-id duplicates
  (backports) removed: **394**.
- **Oracle case**: a `test-z3` unit (the runner reports pass/fail per unit; pass = exit 0 and a
  `PASS` line) defined in the fix's test files, passing in two runs on the base build.
  185 of 191 units pass twice on the base; excluded: `tptp`, `quant_solve`, `lp_evidence`
  (fail on the release itself) and `theory_pb`, `sat_user_scope`, `tptp_crashes` (exceed 1200 s).
- **Gate**: injection applies; tree builds; >=1 oracle case fails in both of two runs; reversing
  the stored injection restores the base byte for byte.
- **Tiers**: *verbatim* = reverse of the fix's implementation hunks (exact or with fuzz);
  *adapted* = an agent (Claude Sonnet 5.5, Opus 5.5 for retries) re-expressed the fix's bug in
  today's code, in a network-less sandbox, with RATIONALE.md tracing each hunk to the fix.
- **Anchor** (adapted): at the fix commit, the fix's implementation reversed (parent code + fix
  tests) fails, in both runs, a case the adapted injection fails, while passing with the fix
  ("exact").
- **Strict**: passes the gate; a failing case is a unit the fix added test code to; triage
  label is bug (and no hand-review override); adapted bugs need an exact anchor.
- **z3test pool** (non-headline, never strict): 320 fixes whose message references an issue
  with a regression file in [z3test](https://github.com/Z3Prover/z3test) (pinned at
  `aff10a93`, 2026-10-30) but that add no in-repo test; oracle = `z3 model_validate=true f.smt2`
  must print `f.expected.out` exactly (238 of 242 files pass twice on the base).
- **Reproducer**: `repro.smt2` whose z3 output or exit status differs between clean and injected
  builds, deterministic over 3 clean runs, verified by the harness (paths normalized; scripts
  printing versions or statistics rejected).

## Funnel

| stage | in-repo pool | z3test pool |
|---|---|---|
| candidates | 394 | 320 |
| triaged bug (Claude Haiku 5.5) | 288 | 298 |
| verbatim tried (reverse applies cleanly/fuzzy) | 173 | 64 |
| verbatim gate | **100** (51 no failing case, 16 build fail, 6 no oracle) | 18 |
| adapted tried (bug-labelled, with oracle) | 180 | 279 |
| adapted gate | **69** (88 gave up, 20 no failure/no change, 3 rejected) | 67 (15 not run: API credential outage + cap) |
| adapted anchors | 29 exact, 30 build fails, 5 none, 3 toolchain, 2 unit missing | 45 exact, 13 inconclusive, 9 build fails |
| strict | **112** (86 verbatim + 26 adapted) | (never strict) |

Non-strict in-repo bugs (57) are kept and labelled: 30 adapted with a failing anchor build
(mostly the fix's tests call APIs the fix introduced, or the reversal removes a file the fix
added), 12 non-bug triage labels, 5 hand-review overrides (suspected triage mislabels), 5 anchor
none, 3 anchors needing CMake >= 3.30, 2 failing units absent at the fix commit.

## Quality review

All 26 strict adapted bugs, and every adapted injection outside the fix's files, were read by
hand. Locality: verbatim 118/118 in the fix's files; adapted 127 same files, 3 same directories,
1 overlapping, 5 disjoint (all z3test pool; 4 are code that moved since the fix, 1 is an analogue
in the other arithmetic solver, flagged in its RATIONALE). Mechanical trace score (share of an
injection's changed lines found among the fix's changed lines): median 0.97. All 9 gates that
rest only on timeouts were re-run at low load with 10x the base time and confirmed.
Known caveats: unit granularity means a "fix-added" case can fail on an assertion added by a
later fix to the same unit; two strict bugs overlap the same code region.

## Known gaps

- Oracles are whole `test-z3` units; finer sub-test granularity is not reported by the runner.
- Anchors could not be built for pre-2016 revisions (no CMake build) and for 3 revisions that
  require CMake >= 3.30 (host had 3.28); old revisions were built with a local `distutils` shim
  and `-include cstdint` where needed (recorded in the anchor records).
- 15 z3test-pool adapted candidates were not retried after an API credential outage (spend cap).
- Triage is by a small model; 5 suspected mislabels were overridden by hand (in meta.json).

## Cost

Agent spend $184.62: triage $24.84, adapted $38.74, Opus retries $27.83, z3test adapted
$58.95, reproducers $34.27 (one timed-out agent booked at its $4 cap).
