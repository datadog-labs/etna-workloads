# OCaml 5.5.2: injected historical bugs

Bugs from the OCaml compiler/runtime fix history, re-injected into the 5.5.2 release as
patches. Every bug is anchored in a real upstream fix commit and verified by tests.

## Counts

- bugs: 572 (88 verbatim, 484 adapted)
- **strict: 121** (30 verbatim, 91 adapted); 121 with a verified reproducer
- reproducers (all bugs): 572 / 572
- strict by year: 2016: 1, 2017: 5, 2018: 16, 2019: 18, 2020: 13, 2021: 16, 2022: 11, 2023: 11, 2024: 14, 2025: 9, 2026: 7
- strict by symptom: accepts-invalid: 27, miscompilation: 19, crash: 15, wrong-output: 14, rejects-valid: 12, wrong-error-message: 11, other: 11, memory: 7, hang: 5

Use `strict` bugs for headline numbers; the others are kept and labelled in `meta.json`.

## Definitions

- **Base**: the release configured as upstream CI configures it for its tests
  (`--enable-ocamltest --enable-native-toplevel`), tests run with the debug runtime
  (`USE_RUNTIME=d`, C assertions enabled).
- **Oracle** (`oracle.json`): test files (ocamltest reports one result per file) from the
  fix's own test files that pass on the base in two runs.
- **Gate**: the injection applies; the tree builds (clean rebuild); at least one oracle test
  fails in two runs; reversing the injection restores the release byte for byte.
- **verbatim**: the fix's implementation hunks, reversed, applied to the release (exactly or
  with fuzz). **adapted**: an agent re-expressed the fix's bug in today's code (`RATIONALE.md`),
  accepted only with an *anchor*: at the original fix commit, the fix's implementation reversed
  fails some of the same oracle tests (`meta.json: anchor.result == "exact"`).
- **strict**: passes the gate; a failing test is a test file the fix itself *added*; triage
  labels it a bug; adapted bugs need an exact anchor and must trace hunk-by-hunk to the fix
  (`traceability == "traces"`); near-duplicates (same fix split over commits) are counted
  once (`duplicate_of`).
- **reproducer**: `reproducer/repro.sh PREFIX` (+ one program file) whose output and exit
  status differ between the clean and the injected installed compiler; verified by the harness.

## Layout

- `bugs/<name>/`: `injection.patch`, `meta.json`, `oracle.json`, `RATIONALE.md`,
  `reproducer/` (`repro.sh`, program, `expected-clean.txt`, `expected-buggy.txt`)
- `patches/<name>.patch`: the same injections, for Marauders (`marauder.toml`)
- `bugs.json`, `bugs.csv`: index
- `bin/`: scripts (below)
- `tool/`: the clean-room pipeline that produced the dataset (mining, gate, agents,
  anchors, traceability check, reproducers, export); see `tool/run_all.sh`. Agents are
  run with the `claude` CLI; set `ETNA_API_KEY_HELPER` to use an `apiKeyHelper` command.
  Two configuration details were made portable after the run, with no change in logic:
  that helper setting (previously site-specific) and the sandbox's deny paths (now
  computed from the tool's location).

## Usage

```sh
bin/setup.sh TREE                   # clone the release tag, configure, build
bin/check-tests.sh TREE BUG         # CLEAN (0) / BUG DETECTED (1)
bin/apply.sh TREE BUG && bin/build.sh TREE
bin/check-tests.sh TREE BUG         # -> BUG DETECTED
bin/check-repro.sh TREE BUG         # installs TREE into TREE/_inst, runs the reproducer
bin/revert.sh TREE BUG && bin/build.sh TREE
```

`bin/build.sh` always rebuilds clean: incremental builds after stdlib/runtime edits can
produce inconsistent-assumption errors.

## Known gaps

- Anchors for fixes older than ocamltest (before about 2017-09) cannot run the oracle (the
  legacy Makefile testsuite was not ported); those adapted bugs are not strict.
- Anchor builds of old revisions use compatibility settings for a modern toolchain (no
  `-Werror`, `CC="gcc -fcommon"`, a fixed-size alternate signal stack); recorded in
  `meta.json: anchor.build_env`.
- Windows-only fixes cannot fail on Linux and were not adapted.
- Some oracle tests are timing-sensitive (e.g. systhreads yield fairness); they passed both
  base runs and failed both injected runs.
- `tool/anchor.py` times out `ocamltest` but not the test programs it started, so an anchor
  whose bug shows as a hang can leave orphaned processes; kill them after a run.

## License

Material derived from OCaml (the injection patches, the reproducers, which are derived from
OCaml's tests, and the test names and commit messages quoted in the records) is licensed under
OCaml's licence, the LGPL-2.1 with OCaml's special exception on linking
(`LGPL-2.1-only WITH OCaml-LGPL-linking-exception`); everything else here is Copyright Datadog, Inc. under
Apache-2.0 (`../LICENSE`). See `LICENSE` and `NOTICE`.

### Notices of changes (LGPL-2.1 section 2)

Each `bugs/<name>/injection.patch` (and its copy `patches/<name>.patch`) is a modification
of the OCaml 5.5.2 files named in its `diff --git` headers: it re-introduces a historical
bug into those files. The upstream fix it is derived from is recorded in
`bugs/<name>/meta.json` (`fix_commit`, `fix_date`, `fix_subject`, `report_links`), and the
original, unmodified source is the OCaml 5.5.2 release
(https://github.com/ocaml/ocaml/tree/5.5.2), which `bin/setup.sh` clones. The
modifications were made in 2026 by Datadog, Inc.
