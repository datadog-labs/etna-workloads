# Rationale: gh-62260 / bpo-18060 ctypes.Structure multi-level subclassing

v3.15.2 already contains the fix (StgInfo instead of StgDictObject). Two hunks reverted:

1. `Modules/_ctypes/stgdict.c` (`PyCStructUnionType_update_stgdict`): `stginfo->length = ffi_ofs + len;` -> `stginfo->length = len;`
   Reverses the fix's stgdict.c hunk. `length` again counts only the class's own fields, not the
   inherited ffi elements, so `PyCStgInfo_clone` (which allocates/copies `length + 1` elements) truncates
   the ffi element array for subclasses of subclasses.
2. `Modules/_ctypes/_ctypes.c` (`_init_pos_args`): restored the pre-fix loop (`i` from 0, `i+index`
   bound, `fields[i]`, `args[i+index]`, return `index + info->length`), which relied on the old
   "own fields only" length meaning. Reverses the fix's _ctypes.c hunks; both are needed to be consistent.

## Oracle result
test_issue18060_a/b/c fail (the run crashes with a segfault, as the test comments describe: atan2 with a
truncated ffi type); later tests in the file are also lost because the process crashed.
