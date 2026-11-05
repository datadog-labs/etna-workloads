# Rationale
Changed hunk: src/interfaces/ecpg/preproc/ecpg.trailer, rule `variable_list: variable_list ',' variable`.
Traces to the fix.patch hunk that adds `mm_strdup(actual_type[struct_level].type_storage)` to the cat_str in that rule.
The current code already stores type_storage (the other hunks are present), so only the use is removed: for varchar/bytea
lists `static varchar a[5], b[5];` is split into separate declarations, and the storage marker (static/extern/etc.) is
omitted from the later ones, so they lose their storage class.

Failing oracle case: src/interfaces/ecpg||preproc/variable
