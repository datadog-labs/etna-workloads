# repl: fix FileHandle leak in history initialization

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 71b36ee68ae492077436708bc4e334ad519046ad applied to v26.13.0 (clean).

Upstream commit message:

```
repl: fix FileHandle leak in history initialization

Ensure that the history file handle is closed if initialization fails or
flushing throws an error. This prevents ERR_INVALID_STATE errors where
a FileHandle object is closed during garbage collection.

PR-URL: https://github.com/nodejs/node/pull/61706
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Gürgün Dayıoğlu <hey@gurgun.day>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
```
