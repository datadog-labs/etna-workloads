# Rationale
File: src/backend/optimizer/plan/setrefs.c, function register_partpruneinfo (the code that fix.patch changed in set_append_references / set_mergeappend_references was since factored into this shared function).

Change: removed the fix_scan_list() calls on initial_pruning_steps and exec_pruning_steps (both hunks of fix_impl.patch). Prune steps then no longer get expression processing in setrefs: Var rtindexes are not offset and so on, so pruning expressions reference wrong or unprocessed rels.

Failing oracle case: src/test/regress||partition_prune
