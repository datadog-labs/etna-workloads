# Rationale

Changed: src/backend/optimizer/util/tlist.c, `split_pathtarget_at_srfs_extended()`.

Traces to the fix.patch hunk that added
`context.current_sgref = get_pathtarget_sortgroupref(target, lci);` ("Tell split_pathtarget_walker about this expr's sortgroupref").
It is now `context.current_sgref = 0;`, so every split_pathtarget_item gets sortgroupref 0.
The sortgroupref labels of target expressions are lost while the SRF targetlist is split.
This is the bug the fix removed: mishandled sortgroupref labels.

Failing oracle case: src/test/regress||select_parallel
