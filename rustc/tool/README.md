# rustc workload pipeline

The tooling that produced `../` (mined, injected, verified and exported the bugs). It
runs on one Linux host with a rust-lang/rust clone; scratch lives in `~/rustc-etna-work`
and results in `~/rustc-etna/data`.

| Step | Entry point |
|---|---|
| Mine candidates, probe reverse-apply | `mine.py`, `probe.py`, `report_probe.py` |
| Base build and two base runs | `slot.py`, `base_runs.sh`, `runner.py` (compiletest runner and output parser) |
| Test-case mapping and oracles | `testmap.py`, `oracle.py` |
| Triage (cheap model) | `triage.py` |
| Verbatim gate | `verbatim.py` |
| Adapted injections (agents) and gate | `adapted.py`, `agent.py`, `llm.py` |
| Anchors at the fix commit | `anchor.py`, `llvm_build.py`, `pycompat/` |
| Reproducers and their harness | `reproducers.py`, `repro.py` |
| Export | `export.py`, `workload_bin/` (becomes `../bin/`) |
| Unattended run (resumable) | `chain.sh` |
| Host protection | `memguard.py`, `memwatch.py`, `validate_slot.py` |

Agents run through the `claude` CLI in headless mode with a sandbox that may write only
their work directory. `ETNA_CREDENTIAL_HELPER`, if set, is a command that must exit 0
before any agent is launched (the run waits otherwise); API errors are recorded as
retryable, never as results. Spend per stage is logged and capped (`llm.py`).
