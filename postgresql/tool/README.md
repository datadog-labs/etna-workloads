# Tooling for the postgresql/ workload (clean-room)

Written from scratch for this workload; it shares no code with `sqlite/tool/`. It was run on
one 16-core Linux host. Scratch lives in `$ETNA_WORK` (default `~/pg-etna-work`), which holds
the upstream clone `pg/` and the worker trees `w/w<N>`.

Stages, in the order they ran (see `REPORT.md` for measured numbers and incidents):

| stage | script | notes |
|---|---|---|
| mine candidates | `mine.py`, `pgpaths.py` | non-merge commits reachable from REL_18_6 that change src/ implementation and src/ tests, with fix wording, `Bug #N`, `Reported-by:` or `Security: CVE` |
| probe | `probe_apply.py` | classifies the reversed implementation diff as clean (`git apply -R --check`), fuzzy (`patch -F3`) or conflict |
| worker trees | `setup_workers.py`, `tree.py` | unconfigured `git archive` export plus a private git index (objects via alternates), configured and built in place; injections are stored as `git diff --binary`, and reversal is verified against the base tree hash |
| build and run | `pgrun.py`, `units.py` | autoconf with cassert, depend, injection points and TAP; pg_regress/isolation/ecpg output and `prove -v` parsing; per-tree TMPDIR; 6 GB per-process address-space limit |
| base | `base.py`, `oracle.py` | every needed unit twice; a case is an oracle case only if it passes both runs |
| verbatim gate | `verbatim.py`, `gate.py` | apply, build, run oracle units twice, reverse, check the bytes |
| triage | `triage.py`, `llm.py` | Haiku, batches of 8, no tools |
| adapted | `adapted.py`, `agent_oracle.py`, `agent_settings.json` | Sonnet agents in a sandbox (writes only to their work dir, no network, local sockets allowed); the harness gates the agent's implementation-only diff |
| re-gate | `regate.py` | used after the /dev/shm incident |
| anchor | `anchor.py` | at the fix commit: run C and C with the fix reversed, two runs each; build-compatibility fallbacks for old trees |
| strict | `strict.py`, `fixadded.py` | fix-added cases come from `git blame` of expected output, or from TAP subtest names |
| reproducers | `repro.py`, `repro_run.sh`, `repro_check.py` | the agent writes repro.sql/sh; the harness checks it: 2 clean runs identical, 2 injected runs different |
| export | `export.py` | writes `../bugs`, `../patches`, `../bugs.csv` |
| orchestration | `chain*.sh`, `redo_after.sh`, `repro_anchored*.sh`, `memwatch.py` | the scripts actually used, kept as run; caps are passed as `--cap` |

Agents are launched with `claude -p --strict-mcp-config`. Set `ETNA_CRED_HELPER` to a command
that exits 0 when API credentials work, so launches wait while credentials are failing.
