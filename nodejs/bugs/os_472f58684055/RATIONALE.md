# os: freeze signals constant

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 472f58684055a15b465e02466548df5def4ed640 applied to v26.13.0 (clean).

Upstream commit message:

```
os: freeze signals constant

Remove the ability to mutate signals constant as doing so can lead to
unexpected behavior, notably when spawning child process.

Fixes: https://github.com/nodejs/node/issues/44749
PR-URL: https://github.com/nodejs/node/pull/61038
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
```
