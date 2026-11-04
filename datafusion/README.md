# DataFusion 55.2.0 workload

288 historical bugs in Apache DataFusion, each re-injected into **DataFusion
55.2.0** (git 500744d5c254) as a patch, for evaluating testing tools. Every
bug comes from an upstream fix commit; the injection brings back the
behaviour that commit fixed.

- Provenance: 186 adapted, 102 verbatim
  - verbatim: the upstream fix's implementation hunks, reversed on 55.2.0
  - adapted: re-expressed on 55.2.0 by a Claude agent (claude-sonnet-5-5)
    where the old hunks no longer apply; RATIONALE.md maps each hunk to the
    fix. Anchored: at the original fix commit, the pre-fix code fails the
    same test files.
- Fix years: 2024: 31, 2025: 85, 2026: 172
- Symptoms: 156 wrong_result, 86 error_handling, 37 crash, 6 other, 3 assert
- Standalone reproducers: 267 of 288 (repro.sql, run with datafusion-cli)
- Locality: 260 subset, 19 disjoint, 9 overlap

Every bug is "strict": a SQL logic test file (`.slt`) that the upstream fix
touched fails with the injection and passes on clean 55.2.0 (in both of two
runs), and triage labels the fix a bug fix. The oracle is the `.slt` file:
DataFusion's Rust unit tests live in the same files as the code, so a
reversed fix could delete them. Implementation files are the Rust sources of
the `datafusion/*` crates.

## Use

    bin/setup.sh /tmp/df-55.2.0                       # 55.2.0 + Marauders variants
    cd /tmp/df-55.2.0
    marauders set --path . --variant datafusion_<id>  # or: bin/apply.sh <id> <tree>
    bin/check-repro.sh <id> /tmp/df-55.2.0            # 1 = bug observed
    bin/check-test.sh  <id> /tmp/df-55.2.0            # 1 = an oracle file fails
    marauders unset --path . --variant datafusion_<id>

The check scripts build what they need with cargo (incrementally; the first
build takes a while). Reproducers run `datafusion-cli -q --format table -f
repro.sql` in an empty directory, with `HOME` set to that directory, `TZ=UTC`
and `RUST_BACKTRACE=0`.

## Per bug (bugs/<id>/)

- injection.patch (also patches/datafusion_<id>.patch)
- meta.json: fix commit, date, subject, issue/PR references, first release
  containing the fix, provenance, labels (kind, symptom, subsystem),
  injected and fix files, locality, anchor
- oracle.json: the `.slt` files that fail (a case is a whole file)
- repro.sql, expected.txt, expected-status.txt, NOTES.md
- RATIONALE.md (adapted only)

The id is the first 12 hex digits of the fix's commit in
https://github.com/apache/datafusion.
