# Rationale
File: src/backend/utils/misc/guc.c, function assignable_custom_variable_name() (the code find_option() now delegates to).
Traces to the fix.patch hunk in find_option() that added the "must not match any previously-reserved prefix" loop over reserved_class_prefix (and the hunk in MarkGUCPrefixReserved that records the prefix).
The loop now iterates over NIL instead of reserved_class_prefix, so reserved prefixes are never rejected. Bogus GUCs in an extension's reserved namespace can be set again, which is the pre-fix behaviour.

Failing oracle case: src/test/regress||guc
