# Re-introduced bug: NodeTracing.getCategories returns a stale category list

**Bug.** `NodeTracing.getCategories` reported only the old, incomplete set of categories (`node`, `node.async`, `node.bootstrap`, `node.fs.sync`, `node.perf`, `node.perf.usertiming`, `node.perf.timerify`, `v8`). It omitted the categories Node actually supports, and `node.async` was a wrong name.

**Hunk (src/inspector/tracing_agent.cc, `TracingAgent::getCategories`).** This corresponds to the single implementation hunk of the fix. Today's code has a longer, alphabetized list that also includes the threadpoolwork categories, and it uses `emplace_back`. I replaced that list with the pre-fix list, re-expressed with today's API. This brings back the old behaviour because the inspector again returns the stale set of categories.

**Failing test.** `parallel/test-inspector-tracing-domain` fails (`not ok`) on both runs. The category comparison against the full list in the test no longer matches.
