# Rationale

Hunk: src/include/tcop/cmdtaglist.h, entry CMDTAG_ALTER_TYPE.
Traces to fix_impl.patch hunk in event_trigger.c `check_table_rewrite_ddl_tag`, which added "ALTER TYPE" as a command tag accepted for table_rewrite event triggers. In REL_18_6 that check is driven by the `table_rewrite_ok` flag in cmdtaglist.h (`command_tag_table_rewrite_ok`). I set it to false for ALTER TYPE, so `CREATE EVENT TRIGGER ... ON table_rewrite WHEN TAG IN ('ALTER TYPE')` is rejected as unsupported again, which restores the bug.

Failing oracle cases:
- src/test/regress||event_trigger
