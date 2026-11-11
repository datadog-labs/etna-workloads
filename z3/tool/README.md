# Pipeline (clean-room)

Python 3.12, git, CMake >= 3.28, Ninja, GCC 13, rsync, bubblewrap (agent sandbox), and the
`claude` CLI for the agent stages. Scratch defaults to `~/z3-etna-work` (`Z3_ETNA_WORK`),
results to `~/z3-etna/data` (`Z3_ETNA_DATA`). `ETNA_CRED_CHECK` may name a command that
must succeed before each agent launch (API credential check); default: none.

| step | script | notes |
|---|---|---|
| mine candidates | `mine.py`, `applycheck.py` | fix signal + impl/test file split (`common.py`), patch-id dedupe, reverse-apply check |
| base build + base tests | `build_base.py`, `base_tests.py`, `base_z3test.py` | Debug (assertions), every unit / z3test file twice |
| verbatim tier | `verbatim.py` | per-slot incremental builds, sources synced by content (`rsync -rlpc`) |
| triage | `triage.py` | Claude Haiku 5.5, one call per commit |
| adapted tier | `adapted.py`, `agents.py` | sandboxed headless agents per slot, `check.sh` build/test loop, harness re-gates |
| anchors | `anchor.py` | fix commit vs fix-with-impl-reversed, one content-synced anchor tree; compat measures for old revisions (`compat/` distutils shim, `-include cstdint`, CMake bootstrap) |
| reproducers | `repro.py` | agent writes `repro.smt2`; harness verifies determinism and difference |
| timeout recheck | `recheck_timeouts.py` | low-load rerun of gates that rest only on timeouts |
| export | `export.py` | bug directories, Marauders patches, index |
| orchestration | `chain.sh`, `chain2.sh` | the unattended runs as executed (resumable stages, per-stage spend caps) |

Shared pieces: `z3lab.py` (process-group kill, memory limits, runner/parser, slot sync, patch
helpers), `gate.py` (gate: impl-only check, reversal check, build, oracle twice).
