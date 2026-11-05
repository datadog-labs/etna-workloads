Changed: src/backend/commands/dropcmds.c, does_not_exist_skipping().

- Removed the `case OBJECT_ACCESS_METHOD:` branch (msg "access method \"%s\" does not exist, skipping"). This traces to the first hunk of fix_impl.patch. Without it, DROP ACCESS METHOD IF EXISTS on a missing AM falls to the default case and raises an error instead of a NOTICE.
- Restored the old default-case message "unexpected object type (%d)" (second hunk).

Failing oracle case: src/test/regress||drop_if_exists
