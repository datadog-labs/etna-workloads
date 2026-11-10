# Re-introduced bug: report missing `javascriptHeap` on OOMError

**Bug.** `TriggerNodeReport(Isolate*, ...)` looked up the Environment via `Environment::GetCurrent(isolate)`, then the Environment-based path re-derived the isolate from `env->isolate()`. During an OOM there may be no current Environment, so `env` was null and the isolate was dropped to null too. The report then had no `javascriptHeap` section, even though a valid isolate was available.

**Change (src/node_report.cc, one hunk).** In the core `TriggerNodeReport(Isolate*, Environment*, ...)`, just before `report::WriteNodeReport(...)`, I added `isolate = nullptr; if (env != nullptr) isolate = env->isolate();`. This corresponds to the fix hunk that removed the same block from the old Environment overload and passed the isolate through unchanged. Because today's code already has the split overloads, restoring that block in the shared core function reproduces the old behaviour. An isolate-only caller whose env is null now loses its isolate.

**Failing tests.** With `--max-heap-size=20`, `report/test-report-fatalerror-oomerror-compact`, `-directory` and `-set` fail with "not ok" (message 'No stack.'). The report lacks `javascriptHeap.memoryLimit`, so `helper.validate` with REPORT_FIELDS fails. `-filename` and `-not-set` still pass. The failures were the same on two runs.
