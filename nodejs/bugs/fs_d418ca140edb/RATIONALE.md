# fs: fix recursive watch error handling

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit d418ca140edb0f253bfd90486f81a0c6efb80718 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
fs: fix recursive watch error handling

Recursive watch inverted the throwIfNoEntry check during setup, causing
the default behavior to suppress ENOENT while the opt-out threw it.
Other setup errors were also silently ignored.

Suppress only ENOENT when throwIfNoEntry is false. Propagate all
other setup failures and close watchers created before a partial
failure.

Signed-off-by: Filip Skokan <panva.ip@gmail.com>
Assisted-by: Codex
PR-URL: https://github.com/nodejs/node/pull/65635
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
