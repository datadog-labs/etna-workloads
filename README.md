# etna-workloads
A collection of case studies with historical bug injections - Repository managed by GRM

Each directory is one target: historical bugs from its fix history,
re-injected into a fixed release as patches, for evaluating testing tools.

| Workload | Target | Upstream license | Bugs | Contents |
|---|---|---|---|---|
| [`sqlite/`](sqlite) | SQLite 3.54.1 | Public domain | 1,300 | injection patches (also [Marauders](https://github.com/alpaylan/marauders) patch variants), upstream test oracles, 1,216 standalone reproducers, and the mining pipeline |
| [`valkey/`](valkey) | Valkey 9.0.7 | BSD-3-Clause | 176 | injection patches (also Marauders patch variants), upstream test oracles, 173 standalone reproducers; mined with the pipeline in `sqlite/tool/` (`ETNA_KIND=valkey`) |
| [`cpython/`](cpython) | CPython 3.15.2 | PSF-2.0 | 1,076 | injection patches in C and Python (also Marauders patch variants), upstream test oracles, 1,035 standalone reproducers; mined with the pipeline in `sqlite/tool/` (`ETNA_KIND=cpython`) |

## Licensing

This repository holds material under more than one license:

- **Datadog-written material** is licensed under the Apache License 2.0
  ([LICENSE](LICENSE), [NOTICE](NOTICE)). That covers tooling, scripts,
  documentation, and the labels and verification records.
- **Material derived from an upstream project** keeps that project's license.
  That covers each workload's injection patches, its reproducers, and the
  upstream test cases and commit messages it quotes. Every workload directory
  has its own `LICENSE`, `NOTICE` and `LICENSE-3rdparty.csv`, which say which
  of its files are derived and under what terms. The root
  [LICENSE-3rdparty.csv](LICENSE-3rdparty.csv) lists every workload's
  upstream.

A workload's directory license takes precedence over the root license for
the files it names.

See [CONTRIBUTING.md](CONTRIBUTING.md) to report problems or add workloads.
