# fs: fix ENOTDIR in globSync when file is treated as dir

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 13a662f55986717313bc5d66e9476e138b681cc8 applied to v26.13.0 (clean).

Upstream commit message:

```
fs: fix ENOTDIR in globSync when file is treated as dir

`fs.globSync` failed with `ENOTDIR` when a path component in a glob
pattern was a file but used as a directory (e.g., 'foo{,/bar}' when
'foo' is a file).

This change aligns `getDirentSync` with the asynchronous `getDirent`
by wrapping the `lstatSync` call in a `try-catch` block to safely
return `null` on such errors.

Fixes: https://github.com/nodejs/node/issues/61257
PR-URL: https://github.com/nodejs/node/pull/61259
Reviewed-By: René <contact.9a5d6388@renegade334.me.uk>
```
