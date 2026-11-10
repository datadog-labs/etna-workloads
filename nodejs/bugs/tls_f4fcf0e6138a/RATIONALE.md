# tls: fix error stack conversion in cryptoErrorListToException()

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit f4fcf0e6138a24a17cadc75c68be62d95a29f242 applied to v26.13.0 (clean).

Upstream commit message:

```
tls: fix error stack conversion in cryptoErrorListToException()

The ncrypto move introduced regressions in
cryptoErrorListToException() by passing in the size of the
vector unnecessarily into the vector constructor and then use
push_back() (which would result in a crash on dereferencing empty
handles during later iteration) and having incorrect logic for
checking the presence of an exception. This patch fixes it.

PR-URL: https://github.com/nodejs/node/pull/56554
Fixes: https://github.com/nodejs/node/issues/56375
Refs: https://github.com/nodejs/node/pull/53803
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
```
