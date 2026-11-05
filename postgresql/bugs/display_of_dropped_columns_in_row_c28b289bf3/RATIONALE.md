# Rationale

Changed hunk: `src/backend/executor/execMain.c`, `ExecBuildSlotValueDescription()`.

Traces to the fix.patch hunk that added `/* ignore dropped columns */ if (...attisdropped) continue;` in the attribute loop of that function. In current code the tupdesc is already passed in (the signature and call-site hunks of the fix are already present), so only the skip remains. I removed it. Dropped columns are now included in the "Failing row contains ..." detail, so their values appear in not-null, check-constraint and WITH CHECK OPTION violation messages.

Failing oracle case: src/test/regress||alter_table
