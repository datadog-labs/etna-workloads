# Valkey 9.0.7 workload

176 historical Valkey/Redis bugs, each re-injected into **Valkey 9.0.7** (git
fe8d406c0b5a) as a patch, for evaluating testing tools. Every bug comes from an
upstream fix commit (Valkey's history includes Redis up to the 2024 fork);
the injection brings back the behaviour that commit fixed.

- Provenance: 124 adapted, 52 verbatim
  - verbatim: the upstream fix's implementation hunks, reversed on 9.0.7
  - adapted: re-expressed on 9.0.7 by a Claude agent (claude-sonnet-5-5),
    where the old hunks no longer apply (much of the pre-2024 code was
    renamed); RATIONALE.md maps each hunk to the fix. Anchored: at the
    original fix commit, the pre-fix code fails the same test cases.
- Symptoms: 83 wrong_result, 27 crash, 21 error_handling, 15 corruption, 12 assert, 9 hang, 7 other, 2 resource_leak
- Standalone reproducers: 173 of 176 (repro.sh: starts a server, drives it with the CLI)
- Locality: 158 subset, 17 disjoint, 1 overlap

Every bug is "strict": a test case the upstream fix itself added fails with
the injection, and passes on clean 9.0.7 (in both of two runs).

## Use

    bin/setup.sh /tmp/valkey-9.0.7                   # 9.0.7 + Marauders variants
    cd /tmp/valkey-9.0.7
    marauders set --path . --variant valkey_<id>     # or: bin/apply.sh <id> <tree>
    make MALLOC=libc
    bin/check-repro.sh <id> /tmp/valkey-9.0.7        # 1 = bug observed
    bin/check-test.sh  <id> /tmp/valkey-9.0.7        # 1 = an oracle case fails
    marauders unset --path . --variant valkey_<id>

The expected outputs come from `make MALLOC=libc OPTIMIZATION=-O1`.

## Per bug (bugs/<id>/)

- injection.patch (also patches/valkey_<id>.patch)
- meta.json: fix commit, date, subject, PR/issue references, first release
  containing the fix, provenance, labels (kind, symptom, subsystem),
  injected and fix files, locality, anchor
- oracle.json: the upstream test cases that fail (and which the fix added)
- repro.sh, expected.txt, expected-status.txt, NOTES.md
- RATIONALE.md (adapted only)

The id is the first 12 hex digits of the fix's commit in
https://github.com/valkey-io/valkey.
