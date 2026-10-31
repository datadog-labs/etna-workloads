# CPython 3.15.2 workload

1076 historical CPython bugs, each re-injected into **CPython 3.15.2** (git
5e58eaad7c58) as a patch, for evaluating testing tools. Every bug comes from an
upstream fix commit (gh-/bpo- referenced, 2017 onwards); the injection brings
back the behaviour that commit fixed.

- Provenance: 589 verbatim, 487 adapted
  - verbatim: the upstream fix's implementation hunks, reversed on 3.15.2
  - adapted: re-expressed on 3.15.2 by a Claude agent (claude-sonnet-5-5)
    where the old hunks no longer apply; RATIONALE.md maps each hunk to the
    fix. Anchored: at the original fix commit, the pre-fix code fails the
    same test cases. The adapted tier covers fixes from 2023 onwards.
- Injected code: 637 Python, 411 C, 28 C and Python
- Symptoms: 470 wrong_result, 244 error_handling, 203 crash, 69 other, 30 hang, 27 resource_leak, 24 assert, 9 corruption
- Standalone reproducers: 1035 of 1076 (repro.py, run with the built interpreter)
- Locality: 1032 subset, 28 disjoint, 16 overlap

Every bug is "strict": a test case the upstream fix itself added fails with
the injection, and passes on clean 3.15.2 (in both of two runs).

## Use

    bin/setup.sh /tmp/cpython-3.15.2                  # 3.15.2 + Marauders variants
    cd /tmp/cpython-3.15.2
    marauders set --path . --variant cpython_<id>     # or: bin/apply.sh <id> <tree>
    ./configure --with-pydebug && make -j
    bin/check-repro.sh <id> /tmp/cpython-3.15.2       # 1 = bug observed
    bin/check-test.sh  <id> /tmp/cpython-3.15.2       # 1 = an oracle case fails
    marauders unset --path . --variant cpython_<id>

The expected outputs come from a `--with-pydebug` build (C assert()s on).
For bugs in Lib/*.py, no rebuild is needed after set/unset.

## Per bug (bugs/<id>/)

- injection.patch (also patches/cpython_<id>.patch)
- meta.json: fix commit, date, subject, gh-/bpo- references, first release
  containing the fix, provenance, labels (kind, symptom, subsystem),
  injected and fix files, locality, anchor
- oracle.json: the upstream test cases (unittest ids) that fail, and which
  the fix added
- repro.py, expected.txt, expected-status.txt, NOTES.md
- RATIONALE.md (adapted only)

The id is the first 12 hex digits of the fix's commit in
https://github.com/python/cpython.
