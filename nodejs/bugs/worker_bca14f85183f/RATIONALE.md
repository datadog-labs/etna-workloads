# worker: protect against user mutating well-known prototypes

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit bca14f85183f059a9b470de2c6d682674a88a1f6 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
worker: protect against user mutating well-known prototypes

PR-URL: https://github.com/nodejs/node/pull/49270
Fixes: https://github.com/nodejs/node/issues/49259
Reviewed-By: Ben Noordhuis <info@bnoordhuis.nl>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
Reviewed-By: Matthew Aitken <maitken033380023@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
```
