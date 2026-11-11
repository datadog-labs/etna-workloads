# etna-workloads
A collection of case studies with historical bug injections - Repository managed by GRM

Each directory is one target: historical bugs from its fix history,
re-injected into a fixed release as patches, for evaluating testing tools.

| Workload | Target | Upstream license | Bugs | Contents |
|---|---|---|---|---|
| [`sqlite/`](sqlite) | SQLite 3.54.1 | Public domain | 1,300 | injection patches (also [Marauders](https://github.com/alpaylan/marauders) patch variants), upstream test oracles, 1,216 standalone reproducers, and the mining pipeline |
| [`valkey/`](valkey) | Valkey 9.0.7 | BSD-3-Clause | 176 | injection patches (also Marauders patch variants), upstream test oracles, 173 standalone reproducers; mined with the pipeline in `sqlite/tool/` (`ETNA_KIND=valkey`) |
| [`cpython/`](cpython) | CPython 3.15.2 | PSF-2.0 | 1,076 | injection patches in C and Python (also Marauders patch variants), upstream test oracles, 1,034 standalone reproducers; mined with the pipeline in `sqlite/tool/` (`ETNA_KIND=cpython`) |
| [`go/`](go) | Go 1.27.3 (compiler) | BSD-3-Clause | 402 | injection patches in the compiler (also Marauders patch variants), upstream test oracles, 383 standalone reproducers; mined with the pipeline in `sqlite/tool/` (`ETNA_KIND=go`) |
| [`datafusion/`](datafusion) | Apache DataFusion 55.2.0 | Apache-2.0 | 288 | injection patches in the Rust crates (also Marauders patch variants), SQL logic test oracles, 267 standalone `repro.sql` reproducers for `datafusion-cli`; mined with the pipeline in `sqlite/tool/` (`ETNA_KIND=datafusion`) |
| [`postgresql/`](postgresql) | PostgreSQL 18.6 (REL_18_6) | PostgreSQL | 1,466 (1,045 strict) | injection patches in the server, client tools and libraries (also Marauders patch variants), upstream pg_regress/isolation/TAP oracles, 1,449 standalone `repro.sql`/`repro.sh` reproducers; mined with the clean-room pipeline in `postgresql/tool/` |
| [`nodejs/`](nodejs) | Node.js v26.13.0 (`lib/` JavaScript, `src/` C++) | MIT | 1,373 (425 strict) | injection patches in the JavaScript core library and C++ bindings (also Marauders patch variants), upstream `tools/test.py` and cctest (gtest) oracles, 608 standalone `repro.js`/`repro.sh` reproducers; mined with the clean-room pipeline in `nodejs/tool/` |
| [`typescript/`](typescript) | TypeScript 6.0.3 (tsc and language service) | Apache-2.0 | 637 (509 strict) | injection patches in the compiler and language service (also Marauders patch variants), upstream compiler-baseline/fourslash/unittest oracles, 637 standalone `repro.sh` reproducers; mined with the clean-room pipeline in `typescript/tool/` |
| [`rustc/`](rustc) | rustc 1.99.1 (compiler) | MIT OR Apache-2.0 | 2,186 (1,739 strict) | injection patches in the compiler (also Marauders patch variants), upstream compiletest oracles (ui, crashes, mir-opt, codegen, incremental, assembly), 2,178 standalone `repro.sh` reproducers; mined with the clean-room pipeline in `rustc/tool/` |

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
