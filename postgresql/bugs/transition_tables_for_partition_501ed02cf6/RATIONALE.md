# Rationale

Changed file: src/backend/commands/tablecmds.c (only the checks from the fix's tablecmds.c hunks were removed; the fix's other hunks were not reverted).

- `ATExecAddInherit`: removed the `FindTriggerIncompatibleWithInheritance(child_rel->trigdesc)` check and its error, plus the `trigger_name` variable. This traces to the fix.patch hunks at `@@ -10933` and `@@ -11014` in tablecmds.c.
- `ATExecAttachPartition`: removed the same check for `attachrel` and the `trigger_name` variable. This traces to the fix.patch hunks at `@@ -13418` and `@@ -13547`.

Without these checks, a table with ROW triggers that use transition tables can become an inheritance child or a partition. Those triggers are not supported in hierarchies, so the table is accepted when it should be rejected with "prevents table ... from becoming ...". The `triggers` regression test expects those errors.

Failing oracle case: src/test/regress||triggers
