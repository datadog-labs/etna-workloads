# vm: expose hasTopLevelAwait on SourceTextModule

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 4612c793cb9007a91cb3fd82afe518440473826e applied to v26.13.0 (clean).

Upstream commit message:

```
vm: expose hasTopLevelAwait on SourceTextModule

Expose `hasTopLevelAwait` and `hasAsyncGraph` on
`vm.SourceTextModule`.

`hasAsyncGraph` requires the module to be instantiated first.

PR-URL: https://github.com/nodejs/node/pull/59865
Fixes: https://github.com/nodejs/node/issues/59656
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Joyee Cheung <joyeec9h3@gmail.com>
```
