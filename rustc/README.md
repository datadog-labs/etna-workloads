# rustc 1.99.1 bug workload

Historical bugs from the Rust compiler's fix history, each re-injected into the
**rustc 1.99.1** release (`58cf8f9c35b355199727627d07ae34a4e2846d67`) as a patch to
`compiler/`. Every bug is anchored in a real upstream fix commit and verified by the
project's own compiletest suites; none is invented. The standard library, LLVM,
submodules and tools are out of scope and never touched.

2,186 bugs, **1,739 strict** (365 verbatim, 1,374 adapted);
2,178 have a standalone reproducer (1,736 of the strict ones).

## Contents

| Path | What |
|---|---|
| `bugs/<id>/injection.patch` | the bug, as a patch to the 1.99.1 tree (`git apply` at the root) |
| `bugs/<id>/meta.json` | fix commit, date, subject, PR and issue links, tier, strict flag and reasons, triage labels, locality, anchor result, review notes |
| `bugs/<id>/oracle.json` | the compiletest cases that pass on 1.99.1 (two runs) and the ones the bug makes fail (two runs) |
| `bugs/<id>/reproducer/` | `repro.sh` plus inputs, and the recorded clean and injected outputs |
| `bugs/<id>/RATIONALE.md` | how the injection relates to the fix (written by the agent for adapted bugs) |
| `patches/<id>.patch` | the same patches, one per file, for [Marauders](https://github.com/alpaylan/marauders) |
| `bugs.csv` | one line per bug |
| `bin/` | set up the release, apply/revert a bug, check it by reproducer or by tests |
| `tool/` | the pipeline that mined, injected, verified and exported these bugs |

## Usage

```sh
bin/setup.sh ~/rust-1.99.1            # clone 1.99.1, build stage-1 rustc + std (CI LLVM)
bin/apply.sh ~/rust-1.99.1 <id>       # inject a bug
bin/check_repro.sh ~/rust-1.99.1 <id> # rebuild, run the reproducer: BUG PRESENT / CLEAN
bin/check_tests.sh ~/rust-1.99.1 <id> # rebuild, run the bug's compiletest cases
bin/revert.sh ~/rust-1.99.1 <id>      # remove it again
```

Rebuilds are incremental (`./x build --stage 1 --keep-stage-std 1 compiler/rustc`): the
injections touch only `compiler/`, so std is built once. If the CI LLVM for 1.99.1 is no
longer downloadable, run `ETNA_BUILD_LLVM=1 bin/setup.sh ...` to build LLVM from the
submodule.

## How the bugs were made

1. **Candidates** (7,604): non-merge commits reachable from 1.99.1 that change
   `compiler/` and test files and read as fixes (issue references, fix wording).
   A cheap model triaged them: bug 6,385, feature 570, refactor 434, performance 113, test-build-doc 102.
2. **Oracle**: the fix's own test cases in the ui, crashes, mir-opt, codegen-llvm,
   codegen-units, incremental and assembly-llvm suites that pass in two runs on 1.99.1.
3. **Verbatim** (970 tried, 670 pass the gate): the reverse of
   the fix's compiler hunks, applied to 1.99.1.
4. **Adapted** (1,854 tried, newest first, 1,516 pass the gate): where the
   reversal no longer applies or no longer fails, an agent re-expresses the fix's bug in
   today's code; every changed hunk must trace to a hunk of the fix (RATIONALE.md).
5. **Gate** (all must hold): the patch applies, the compiler builds, at least one
   oracle case fails in two runs, and reversing the patch restores 1.99.1 byte for byte.
6. **Anchor** (adapted only): at the original fix commit, the fix's non-test changes
   reversed (the parent's code with the fix's tests) must fail some of the same cases.
   1,516 anchors: exact 1,427, anchor_fails_other 39, anchor_no_failure 39, anchor_build_failed 11.
7. **Strict** = gate + a failing case that the fix itself added + triage label "bug" +
   (adapted) anchor "exact". Looser bugs are kept and labelled (`strict: false`,
   `loose_reasons`): no failing case added by the fix 353, anchor anchor_no_failure 39, anchor anchor_fails_other 39, triage label feature 18, triage label refactor 13, anchor anchor_build_failed 11, triage label performance 7, triage label test-build-doc 2.
8. **Reproducers**: a script whose output and exit status differ between the clean and
   the injected compiler, deterministic on the clean one, verified by a harness (never
   by an agent's word). Every exported reproducer was re-run from this directory with a
   clean 1.99.1 compiler and reproduces its recorded clean output.

Strict bugs by symptom: ice 677, wrong-diagnostic 277, bad-suggestion 240, spurious-error 167, missing-diagnostic 138, accepts-invalid 110, wrong-mir-or-codegen 58, unsound 25, other 22, miscompile 14, hang-or-overflow 10, incremental 1. By fix year: 2020: 2, 2021: 4, 2022: 5, 2023: 458, 2024: 449, 2025: 449, 2026: 372.

Agent spend: adapted $200.88, adapted-retry $53.19, repro $27.05, triage $4.81, smoke $0.01; total $285.95.

## Caveats

- Adapted attempts ran newest first under a spend cap, so fixes before 2023 are
  barely represented.
- Locality (strict adapted: same-files 1,021, same-crates 182, disjoint 104, overlapping 67) compares file paths;
  many "disjoint" injections sit in code the fix touched that later moved crates.
- A hand review of 20 random strict adapted bugs found 14 faithful, 3 synthesised, 2 faithful-partial, 1 beyond-fix;
  flagged bugs carry `review` in meta.json (flagged, not dropped).
- Some anchors needed help to build old revisions: a `distutils` import shim for
  bootstraps from before 2023-01-30 (`anchor.python_compat` in meta.json) and LLVM
  built from the fix commit's own `src/llvm-project` submodule.
- Two compiletest cases exceed a 6 GiB per-process memory limit on 1.99.1 and are not
  used as oracles.

## License

See [LICENSE](LICENSE), [NOTICE](NOTICE) and [LICENSE-3rdparty.csv](LICENSE-3rdparty.csv):
material derived from the Rust project keeps its license (MIT OR Apache-2.0); everything
written for this workload is Copyright Datadog, Inc. under the Apache License 2.0.
