Two OrderedDicts with distinct-but-equal keys; the key's __eq__ clears d1 on its 2nd call
(which happens while odict_eq walks the linked lists, after dict's own eq pass).
Clean: RuntimeError "OrderedDict mutated during iteration". Buggy: no od_state check, so the
comparison silently returns a result (see output) instead of raising.
