# async_hooks: enabledHooksExist shall return if hooks are enabled

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 926162a2eafa2cf53dac3028c9d6faa07f5081f2 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
async_hooks: enabledHooksExist shall return if hooks are enabled

Correct the implementaton of enabledHooksExist to return true if
there are enabled hooks.

Adapt callsites which used getHooksArrays() as workaround.

PR-URL: https://github.com/nodejs/node/pull/61054
Fixes: https://github.com/nodejs/node/issues/61019
Refs: https://github.com/nodejs/node/pull/59873
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Gürgün Dayıoğlu <hey@gurgun.day>
```
