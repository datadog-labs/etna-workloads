# Node.js v26.13.0 bug workload

Historical bugs from the Node.js fix history, each re-injected into the
**v26.13.0** release (`18b32a3b1552e199a01f1a8d9fd64aa756d3b75b`) as a patch to
`lib/` (JavaScript core) or `src/` (C++). Every bug is anchored in a real
upstream fix commit and verified by the project's own tests; none is invented.
Bundled dependencies (`deps/`: V8, libuv, OpenSSL, llhttp, ...) are out of scope
and never touched.

## Contents

| Path | What |
|---|---|
| `bugs/<id>/injection.patch` | the bug: a diff from the release to the buggy tree (`lib/`, `src/` only) |
| `bugs/<id>/meta.json` | fix commit, date, subject, PR / report links, CVE, tier, triage labels, locality, identifier trace, anchor, failing cases, reproducer |
| `bugs/<id>/oracle.json` | oracle cases, their two base runs, failing cases, the two injected runs |
| `bugs/<id>/RATIONALE.md` | adapted tier: the agent's hunk-by-hunk mapping to the fix; verbatim tier: the upstream commit message |
| `bugs/<id>/repro.js` or `repro.sh` | standalone reproducer (when one was verified) |
| `patches/<id>.patch` | the same injections, laid out for [Marauders](https://crates.io/crates/marauders) (`marauder.toml`) |
| `bin/` | `setup.sh`, `apply.sh`, `revert.sh`, `check-repro.sh`, `check-tests.sh` (wrappers around `bin/etna.py`) |
| `bugs.json`, `bugs.csv` | all `meta.json` records in one file / one row per bug |
| `tool/` | the clean-room tooling that produced the dataset (see `tool/` docstrings; entry points `mine.py`, `gate.py`, `adapted.py`, `anchor.py`, `repro.py`, `export.py`) |

## Usage

```sh
bin/setup.sh ~/node                       # clone v26.13.0, ./configure --debug-node, build (~1 h cold)
bin/apply.sh ~/node querystring_dd4715a6ba57   # apply a bug and rebuild (incremental, ~1 min)
bin/check-tests.sh ~/node querystring_dd4715a6ba57   # BUG (exit 1) / CLEAN (exit 0)
bin/check-repro.sh ~/node querystring_dd4715a6ba57   # BUG / CLEAN via the reproducer
bin/revert.sh ~/node querystring_dd4715a6ba57
```

With Marauders: after `setup.sh`, the checkout root contains `marauder.toml` and
`patches/`; each patch is one variation (activated by `git apply`).

Requirements: Linux x64, git, python3, make, gcc >= 13.2 or clang >= 19.1; the
`openssl` CLI for the reproducers that generate TLS objects.

## How the bugs were made

1. **Candidates**: non-merge commits reachable from v26.13.0 that change `lib/` or
   `src/` *and* `test/`, with a fix signal (`Fixes:` trailer, `Fixes #N`, CVE-ID,
   hackerone report, fix wording); backport duplicates (same PR-URL or patch-id)
   dropped: 3,864.
2. **Base**: v26.13.0 built with `./configure --debug-node` (Node assertions on),
   tests run with the project's `tools/test.py` (one case per test file; WPT per
   sub-test; C++ gtest per `TEST`, one process per case). Every needed case ran
   twice: 3,479 pass in both runs and are oracle-eligible; no flaky case.
3. **Gate** (all must hold): injection applies; tree builds; at least one oracle
   case fails in both of two runs; reversing the stored injection restores the
   release byte for byte.
4. **Tiers**: *verbatim* = reverse of the fix's implementation hunks (471 bugs);
   *adapted* = an agent (Claude Sonnet 5.5; Opus 5.5 for retries) re-expressed the
   fix's bug in today's code, verified independently by the gate (902 bugs).
5. **Anchor** (adapted): at the fix commit, the fix's implementation reversed
   (parent code + fix tests) must fail some of the same cases, which pass at the
   fix ("exact").
6. **Strict** (headline): gate passes, a failing case was *added by the fix*,
   triage label is "bug", adapted bugs have an exact anchor, and timeout-only
   failures were confirmed on a quiet machine. **425 strict bugs** (169 verbatim,
   256 adapted). All other bugs are included and labelled loose with
   `not_strict_reasons`.
7. **Reproducers**: agent-written standalone scripts, verified by the harness
   (3 identical runs on the clean build, different output/exit on the buggy
   build): 608 bugs (417 strict).

## Caveats

- `locality` compares file paths; much "disjoint" code was moved (e.g.
  `lib/repl.js` -> `lib/internal/repl/completion.js`). `id_trace` (share of the
  injection's changed identifiers found in the fix's changed lines) is a better
  signal; adapted bugs with `id_trace < 0.3` deserve a look. A hand review found
  about 5% of adapted bugs not traceable to their fix and ~10% borderline.
- Anchors of 2018-2019 revisions could not be built (configure needs Python 2);
  older revisions were built with compatibility workarounds (gcc 13 standard
  headers, clang 18 fallback, `--openssl-no-asm`, libatomic, gyp `'rU'`), recorded
  per bug. Anchors of non-strict-capable adapted bugs were still running at export
  time ("anchor: not run yet").
- Reproducers that need TLS keys, certificates or CRLs generate them at run time
  with the `openssl` CLI in a private temporary directory (same key types, names,
  serials, dates and extensions as the objects they were written with); no key
  material is stored in this directory.

## License

Material derived from Node.js (the injection patches, and the Node.js test names,
code excerpts and commit messages quoted in the per-bug records) is licensed under
the Node.js license (MIT, text verbatim in `LICENSE`). Everything else in this
directory (bin/, tool/, this README, the reproducers, labels and verification
records) is Copyright Datadog, Inc. and licensed under the Apache License 2.0
(`../LICENSE`). See `LICENSE`, `NOTICE` and `LICENSE-3rdparty.csv`.
