# perf_hooks: move non-standard performance properties to perf_hooks

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 51a57f2b3629e733773f1b9ade70c8abcee5eb8c applied to v26.13.0 (fuzzy).

Upstream commit message:

```
perf_hooks: move non-standard performance properties to perf_hooks

`performance.eventLoopUtilization` and `performance.timerify` are not
part of the Web API. Expose these two functions directly on the
`perf_hooks` module.

PR-URL: https://github.com/nodejs/node/pull/60370
Fixes: https://github.com/nodejs/node/issues/60368
Reviewed-By: Joyee Cheung <joyeec9h3@gmail.com>
Reviewed-By: Marco Ippolito <marcoippolito54@gmail.com>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
```
