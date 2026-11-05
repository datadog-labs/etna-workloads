# Rationale

File: src/backend/commands/tablecmds.c, function ATExecAlterConstrDeferrability (the current home of the trigger loop from ATExecAlterConstraint).

Traces to the fix.patch hunk that added the `tgfoid` filter (only RI_FKey_noaction_del/upd and RI_FKey_check_ins/upd triggers are updated). I removed that `continue` filter. Now ALTER CONSTRAINT ... DEFERRABLE / INITIALLY DEFERRED overwrites tgdeferrable and tginitdeferred on every trigger of the constraint. That includes the cascade, set-null, set-default and restrict action triggers, which must keep their original properties. This is the original bug.

Oracle case expected to fail: src/test/regress||alter_table
