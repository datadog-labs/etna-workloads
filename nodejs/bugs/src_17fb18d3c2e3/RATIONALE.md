# src: fix slice of slice of file-backed Blob

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 17fb18d3c2e3936119774a6079b10cce5c61dd5d applied to v26.13.0 (clean).

Upstream commit message:

```
src: fix slice of slice of file-backed Blob

The value for `new_end` was wrong: While the members `start_` and `end_`
refer to the entire length of the file, the parameters `start` and `end`
are relative to the current slice.

The new end would apparently have the current start_ subtracted from it,
and the length would possibly overflow when the FdEntry is asked for its
size or when get_reader is called, resulting in a subslice which extends
past the current slice, which shouldn't be possible. Add a CHECK if this
happens, rather than returning data outside the current slice.

There aren't any C++ tests for FdEntry, and on the javascript side there
isn't a way to ask the blob handle for its nominal size. That size could
be a large uint64, which gets converted to int64 to when FileHandle::new
is called, which interprets a negative length as unlimited.

Fixes: https://github.com/nodejs/node/issues/53908
PR-URL: https://github.com/nodejs/node/pull/53972
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
