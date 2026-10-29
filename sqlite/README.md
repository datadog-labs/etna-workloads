# sqlite-etna

Historical SQLite bugs, frontported onto **SQLite 3.54.1** as injection
patches, for evaluating testing tools: the etna approach applied to SQLite's
fix history.

- [`workload/`](workload): the dataset. 1,300 bugs, each with its injection
  patch, upstream test oracle, standalone reproducer (1,216 of them) and
  metadata. See [workload/README.md](workload/README.md).
- [`tool/`](tool): the pipeline that mined and verified them.

## Setting and unsetting bugs with Marauders

The bugs are [Marauders](https://github.com/alpaylan/marauders) patch
variants (`workload/patches/sqlite_<id>.patch`):

    workload/bin/setup.sh /tmp/sqlite-3.54.1      # SQLite 3.54.1 + the variants
    cd /tmp/sqlite-3.54.1
    marauders list  --path .                      # one variant per bug
    marauders set   --path . --variant sqlite_<id>
    marauders unset --path . --variant sqlite_<id>

One bug is active at a time; `unset` restores 3.54.1 byte for byte. Without
Marauders, `workload/bin/apply.sh <id> <tree> [-R]` does the same.

Not yet a full ETNA workload: there is no `etna.toml`/`steps.json`, and no
mapping of bugs to properties and witnesses.

## Pipeline (`tool/`)

| Stage | Command | Output |
|---|---|---|
| mine | `sqlite_etna.py mine` | candidates: non-merge commits reachable from 3.54.1 that change `src/`/`ext/` and a `*.test`, with a fix-like subject |
| base | `sqlite_etna.py base` | testfixture at 3.54.1 (`--all --geopoly --session --debug`, `-O0`); every needed test file run once |
| verbatim | `sqlite_etna.py verbatim` | the reverse of each fix's implementation hunks applied to 3.54.1 |
| triage | `triage.py` | bug / feature / performance / refactor labels, symptom, subsystem (Claude) |
| adapt | `adapt.py run` | a Claude agent re-expresses the bug on 3.54.1 where the reversal fails |
| anchor | `adapt.py anchor` | the pre-fix code at the original fix commit fails the same test cases |
| repro | `repro.py run` | a Claude agent turns the failing test cases into repro.sql / repro.sh |
| export | `export.py` | `workload/` |

**Oracle.** The test cases in the fix's own test files that pass on 3.54.1;
a bug is *strict* when a case the fix added fails with the injection.

**Verbatim** injections are the upstream code itself. **Adapted** ones are
confirmed only if they build, make a fix-added case fail, revert to 3.54.1
byte for byte, and pass the anchor with an exact signature.

The pipeline ran on a Datadog workspace (16 cores); its records (`state/`,
about 220 MB) are not in this repository.
