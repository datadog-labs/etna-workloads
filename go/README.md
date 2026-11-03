# Go 1.27.3 compiler workload

402 historical bugs in the Go compiler (cmd/compile), each re-injected into
**Go 1.27.3** (git 2aae1000ea1d) as a patch, for evaluating testing tools.
Every bug comes from an upstream fix commit with a "Fixes #N" line; the
injection brings back the behaviour that commit fixed.

- Provenance: 301 adapted, 101 verbatim
  - verbatim: the upstream fix's implementation hunks, reversed on 1.27.3
  - adapted: re-expressed on 1.27.3 by a Claude agent (claude-sonnet-5-5)
    where the old hunks no longer apply; RATIONALE.md maps each hunk to the
    fix. Anchored: at the original fix commit, the pre-fix code fails the
    same test cases. The adapted tier covers fixes from 2020 onwards.
- Fix years: 2017: 1, 2018: 1, 2020: 34, 2021: 78, 2022: 69, 2023: 66, 2024: 47, 2025: 47, 2026: 59
- Symptoms: 175 wrong_result, 142 crash, 54 error_handling, 13 other, 8 assert, 4 corruption, 4 hang, 2 resource_leak
- Standalone reproducers: 383 of 402 (repro.go or repro.sh)
- Locality: 289 subset, 85 disjoint, 28 overlap

Every bug is "strict": a test case the upstream fix itself added fails with
the injection, and passes on clean 1.27.3 (in both of two runs). Only the
compiler is in scope (not the runtime or standard library), and
architecture-specific fixes appear only when they are observable on amd64.

## Use

    bin/setup.sh /tmp/go-1.27.3                   # 1.27.3 + Marauders variants
    (cd /tmp/go-1.27.3/src && GOROOT_BOOTSTRAP=<go >= 1.24> ./make.bash)
    cd /tmp/go-1.27.3
    marauders set --path . --variant go_<id>      # or: bin/apply.sh <id> <tree>
    bin/go install cmd/compile
    bin/check-repro.sh <id> /tmp/go-1.27.3        # 1 = bug observed
    bin/check-test.sh  <id> /tmp/go-1.27.3        # 1 = an oracle case fails
    marauders unset --path . --variant go_<id> && bin/go install cmd/compile

A release toolchain identifies its compiler by version, not by content, so a
shared build cache would mix clean and injected compilers. The check scripts
use one cache per compiler binary, under the GOROOT (.etna-gocache/<hash>);
delete that directory to reclaim space. Your own go commands with an injected
compiler should use a separate GOCACHE as well.

## Per bug (bugs/<id>/)

- injection.patch (also patches/go_<id>.patch)
- meta.json: fix commit, date, subject, issue references, first release
  containing the fix, provenance, labels (kind, symptom, subsystem),
  injected and fix files, locality, anchor
- oracle.json: the upstream tests that fail (test/ programs as
  Test/<path>, compiler package tests as pkg:<import path>), and which the
  fix added
- repro.go or repro.sh, expected.txt, expected-status.txt, NOTES.md
- RATIONALE.md (adapted only)

The id is the first 12 hex digits of the fix's commit in
https://github.com/golang/go.
