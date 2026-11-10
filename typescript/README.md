# TypeScript compiler (tsc) v6.0.3: historical bug workload

637 historical bugs of the TypeScript compiler and language service, each
re-injected into release **v6.0.3** (the last JavaScript-based compiler) as a patch
to `src/compiler/` or `src/services/`. Every bug is anchored in a real upstream fix
commit and verified by the project's own tests: at least one of the fix's test cases
passes on v6.0.3 in two runs and fails in two runs with the patch applied.

**509 strict bugs** (headline set): 308 verbatim, 201 adapted.
The other 128 are kept, labelled, for looser use (`meta.json: strict=false`
with `not_strict_reasons`). Reproducers: 637/637 bugs (509/509 strict) have a
standalone reproducer verified by the harness.

## Tiers and labels

- **verbatim**: the reverse of the fix's implementation hunks, applied to v6.0.3
  (exactly, or with fuzz where only context moved; changed lines identical to the fix).
- **adapted**: the reversal no longer applies or no longer fails; an agent re-expressed
  the fix's bug in today's code (`RATIONALE.md` maps each hunk to the fix). Accepted only if
  the gate passes in a fresh tree.
- **strict**: gate passes, a failing case was added by the fix itself, triage labels the
  commit a bug, and for adapted bugs the *anchor* is exact: at the original fix commit, the
  fix's implementation reversed (parent code + fix tests) fails some of the same cases.
- `meta.json` also gives the fix commit/date/subject/links, triage symptom and subsystem
  (small-model triage), locality of the injection vs the fix's files
  (`same`/`overlap`/`disjoint`), anchor status, failing cases and oracle size.

## Strict bugs by symptom

| symptom | bugs |
|---|---|
| wrong-language-service-result | 160 |
| wrong-type | 91 |
| crash | 78 |
| false-error | 61 |
| wrong-declaration-emit | 27 |
| missing-error | 26 |
| wrong-emit | 25 |
| wrong-module-resolution | 19 |
| wrong-diagnostic-text | 13 |
| wrong-build-or-watch | 7 |
| other | 2 |

## Strict bugs by fix year

| year | bugs |
|---|---|
| 2023 | 247 |
| 2024 | 165 |
| 2025 | 56 |
| 2022 | 28 |
| 2026 | 8 |
| 2019 | 2 |
| 2016 | 1 |
| 2020 | 1 |
| 2021 | 1 |

## Strict bugs by oracle test kind (a bug can have several)

| test runner | bugs |
|---|---|
| fourslash | 225 |
| compiler | 215 |
| conformance | 110 |
| unittest | 46 |
| fourslash-server | 15 |
| transpile | 1 |

## Layout

- `bugs/<name>/`: `injection.patch`, `meta.json`, `oracle.json` (test case -> runner, mocha
  grep, added-by-fix), `RATIONALE.md`, `repro/` (`repro.sh` + inputs, `expected_clean.txt`,
  `expected_injected.txt`, `NOTES.md`).
- `patches/<name>.patch`: the same injections, for Marauders (`marauder.toml`).
- `bugs.json`: one-line summary per bug.
- `tool/`: the clean-room pipeline that built this workload (mining, probe, base runs, gate,
  triage, adapted/reproducer agents, anchors, export; see `tool/REPORT.md` for the run).
- `bin/etna.py`: set-up and checks (needs git, Node.js >= 20, npm, Python 3, network for setup):

```
bin/etna.py setup DIR            # clone TypeScript v6.0.3, npm ci, build (about 1 minute)
bin/etna.py set DIR BUG          # apply a bug and rebuild (about 50 s)
bin/etna.py check-repro DIR BUG  # BUG / CLEAN by the reproducer (exit 1 / 0)
bin/etna.py check-tests DIR BUG  # BUG / CLEAN by the bug's failing test cases (exit 1 / 0)
bin/etna.py unset DIR BUG        # reverse it and rebuild
```

Reproducers are run with `TSC` (built/local/tsc.js) and `TYPESCRIPT` (built/local/typescript.js)
set; output is compared after replacing the checkout path with `<TS>`. The clean output is
deterministic; injected output can vary for some crashes (e.g. stack overflows), so
`check-repro` reports BUG whenever the output differs from `expected_clean.txt`.

## Known gaps

- Only fixes from November 2022 onwards (hereby build, ES modules) could be adapted and
  anchored; older fixes appear only when their reversal still applies verbatim.
- Oracle = test cases in the fix's own test files; a bug may break other tests too.
- Unittest cases count as "added by the fix" only when the fix added the unittest file or a
  baseline whose scenario name appears in the case title.
- Triage is a single small-model pass; labels can be wrong (they gate the strict set).

## License

TypeScript is Copyright (c) Microsoft Corporation, Apache-2.0. Patches, reproducers and the
quoted test names/commit subjects are derived from TypeScript (Apache-2.0); `tool/` and `bin/`
are Datadog-written (Apache-2.0). See `LICENSE`, `NOTICE` and `LICENSE-3rdparty.csv`.
