# Rationale

All hunks are in src/src/backend/utils/misc/guc.c and trace to the single guc.c hunk set in fix_impl.patch.

- `valid_custom_variable_name()`: `bool saw_sep` is changed back to `int num_sep`, incremented on each dot. The final check is `num_sep == 1` instead of `saw_sep`. This restores the old rule that custom GUC names must have exactly two components, so names like `a.b.c` are rejected again. It traces to the first three hunks of the fix.
- `find_option()`: the errdetail is reverted to "Custom parameter names must be of the form \"identifier.identifier\"." It traces to the last hunk of the fix.

Failing oracle case: src/test/regress||guc
