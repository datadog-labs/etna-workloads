# events: fix bug listenerCount don't compare wrapped listener

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 0c8539e336bfe81c816a85dce71894dbef9ab371 applied to v26.13.0 (clean).

Upstream commit message:

```
events: fix bug listenerCount don't compare wrapped listener

When add listener by once, it will be wrapped into another function.
And when pass listener and there is just one event listener added by
once, it will return 0 even if passed listener equal wrapped event
listener.

Refs: https://github.com/nodejs/node/pull/46523
PR-URL: https://github.com/nodejs/node/pull/48592
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
Reviewed-By: Minwoo Jung <nodecorelab@gmail.com>
```
