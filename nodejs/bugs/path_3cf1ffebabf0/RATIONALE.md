# path: fix win32 parse regression

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 3cf1ffebabf0f6a862ea80cd9cf14adbd073b3ef applied to v26.13.0 (clean).

Upstream commit message:

```
path: fix win32 parse regression

This fixes the parse function for single character input that are not
a path separator.

PR-URL: https://github.com/nodejs/node/pull/26912
Fixes: https://github.com/nodejs/node/issues/26911
Reviewed-By: Ben Noordhuis <info@bnoordhuis.nl>
Reviewed-By: Michaël Zasso <targos@protonmail.com>
```
