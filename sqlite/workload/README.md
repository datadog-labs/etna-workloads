# sqlite-etna 3.54.1

1300 historical SQLite bugs, each re-injected into **SQLite 3.54.1** (git
57520227c953) as a patch, for evaluating testing tools. Every bug
comes from an upstream fix commit; the injection brings back the behaviour
that commit fixed.

- Provenance: 945 adapted, 355 verbatim
  - verbatim: the upstream fix's implementation hunks, reversed exactly (or
    with fuzz) on 3.54.1
  - adapted: re-expressed on 3.54.1 by a Claude agent (claude-sonnet-5-5)
    where the old hunks no longer apply; RATIONALE.md maps each hunk to the
    fix. Anchored: at the original fix commit, the pre-fix code fails the
    same upstream test cases (signature_equivalence = exact).
- Symptoms: 694 wrong_result, 210 crash, 136 error_handling, 118 assert, 62 other, 60 corruption, 11 hang, 9 resource_leak
- Standalone reproducers: 1216 of 1300 (1098 sql, 118 sh, 84 None); the rest keep only the
  test-level oracle (mostly simulated OOM/IO-error and crash-test bugs)
- Locality: 1216 subset, 53 disjoint, 31 overlap (injected files vs the fix's files; "disjoint"
  includes code that moved, e.g. ext/misc/json1.c -> src/json.c)
- Found by ephyra: 10. Most other ephyra-found bugs were fixed upstream after
  3.54.1 was cut, so 3.54.1 already contains them unfixed.

Every bug here is "strict": a test case the upstream fix itself added fails
with the injection, and passes on clean 3.54.1.

## Use

    bin/apply.sh <id> <sqlite-3.54.1-tree>          # inject   (-R removes it)
    ./configure --all --geopoly --session --debug CFLAGS="-g -O0"
    make sqlite3 testfixture
    bin/check-repro.sh <id> ./sqlite3               # 1 = bug observed
    bin/check-test.sh  <id> ./testfixture <tree>    # 1 = an oracle case fails

Two reproducers (bbbb0e8053a8, e3602be8fd57) compile a loadable extension:
set SQLITE_INC to the built tree's src/ directory for them.

The expected outputs come from that build (a debug build, so assert()s
fire); other build options can change error texts and plans.

## Per bug (bugs/<id>/)

- injection.patch: apply with patch -p1 to 3.54.1
- meta.json: fix commit and Fossil id, date, subject, report links, first
  release containing the fix, provenance, triage labels (kind, symptom,
  subsystem), injected and fix files, locality, anchor
- oracle.json: the upstream test cases that fail (and which the fix added)
- repro.sql or repro.sh, expected.txt, expected-status.txt, NOTES.md
- RATIONALE.md (adapted only)

The id is the first 12 hex digits of the fix's git commit in the official
mirror (https://github.com/sqlite/sqlite); fix_fossil is the Fossil check-in.
