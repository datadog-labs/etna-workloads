# fs: honor dereference for symlinks nested in cpSync trees

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit cb9995be4d37c634ef9f70982d078a5ee79ce810 applied to v26.13.0 (clean).

Upstream commit message:

```
fs: honor dereference for symlinks nested in cpSync trees

When no filter is given, cpSync copies directory contents in C++. That
loop recreated every symlink it found, consulting dereference only for
the subdirectory-of-self guards, so a symlink nested in the tree was
copied as a link even with dereference set. Only a symlink passed as src
was dereferenced, because that one is resolved by stat() in JavaScript
before the C++ copy starts.

The directory and regular file branches already follow symlinks, so
links that resolve to those types can fall through to them. A link whose
target cannot be reached has nothing to copy, and uv_fs_stat() reports
the underlying filesystem error.

When following a link, preserve the existing force and errorOnExist
behavior for occupied destinations. Under force, remove an existing
destination first so copying does not write through a destination
symlink.

Signed-off-by: Christian Aurich <christian.aurichzm@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65731
Fixes: https://github.com/nodejs/node/issues/59168
Reviewed-By: Shelley Vohr <shelley.vohr@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
