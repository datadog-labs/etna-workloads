# etna-workloads
A collection of case studies with historical bug injections - Repository managed by GRM

Each directory is one target: historical bugs from its fix history,
re-injected into a fixed release as patches, for evaluating testing tools.

| Workload | Target | Bugs | Contents |
|---|---|---|---|
| [`sqlite/`](sqlite) | SQLite 3.54.1 | 1,300 | injection patches (also [Marauders](https://github.com/alpaylan/marauders) patch variants), upstream test oracles, 1,216 standalone reproducers, and the mining pipeline |
